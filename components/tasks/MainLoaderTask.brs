' Note that we need to import this file in MainLoaderTask.xml using relative path.
sub Init()
    ' set the name of the function in the Task node component to be executed when the state field changes to RUN
    ' in our case this method executed after the following cmd: m.contentTask.control = "run"(see Init method in MainScene)
    m.top.functionName = "GetContent"
end sub

sub GetContent()
    ' request the content feed from the API
    xfer = CreateObject("roURLTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetURL("https://gist.githubusercontent.com/srajagop/ed6a725f4a522af062e9efa17ecc8b40/raw/ea233d4b8f52d10d6224b1c0a940a9853434eef9/moviedb.json")
    rsp = xfer.GetToString()
    rootChildren = []
    rows = {}

    ' parse the feed and build a tree of ContentNodes to populate the GridView
    json = ParseJson(rsp)
    json = marshallResponse(json)

    ' Populate Popular / Trending first
    row = {}
    row.title = Capitalize("populars")
    row.children = []
    for each item in json.populars ' parse items and push them to row
        itemData = GetItemData(item)
        row.children.Push(itemData)
    end for
    rootChildren.Push(row)
    json.Delete("populars")

    if json <> invalid
        for each category in json.keys()
            value = json.Lookup(category)
            if Type(value) = "roArray" ' if parsed key value having other objects in it
                if category <> "series" ' ignore series for this phase
                    row = {}
                    row.title = Capitalize(category)
                    row.children = []
                    for each item in value ' parse items and push them to row
                        itemData = GetItemData(item)
                        row.children.Push(itemData)
                    end for
                    rootChildren.Push(row)
                end if
            end if
        end for
        ' set up a root ContentNode to represent rowList on the GridScreen
        contentNode = CreateObject("roSGNode", "ContentNode")
        contentNode.Update({
            children: rootChildren
        }, true)
        ' populate content field with root content node.
        ' Observer(see OnMainContentLoaded in MainScene.brs) is invoked at that moment
        m.top.content = contentNode
    end if
end sub

function GetItemData(video as Object) as Object
    item = {}
    ' populate some standard content metadata fields to be displayed on the GridScreen
    ' https://developer.roku.com/docs/developer-program/getting-started/architecture/content-metadata.md
    if video.longDescription <> invalid
        item.description = video.description
    else
        item.description = video.description
    end if
    item.hdPosterURL = video.trailerPreview
    item.title = video.name
    item.releaseDate = video.releasedAt
    item.id = video.id
    ' populate length of content to be displayed on the GridScreen
    item.length = video.duration
    ' populate meta-data for playback
    item.url = video.trailer
    item.streamFormat = "m4v"
    return item
end function

function Capitalize(str as String) as String
    leadingAlphabet = Left(str, 1)
    leadingAlphabetAscii = Asc(leadingAlphabet) - 32
    return Chr(leadingAlphabetAscii) + Right(str, Len(str) - 1)
end function

'' just to filter out generes as categories
function marshallResponse(resp as Object) as Object
    movies = resp.movies
    'categories = {}
    for each movie in movies
        genres = movie.genres
        for each genre in genres 
            if Type(resp[genre]) = "roArray" then
                resp[genre].Push(movie)
            else
                resp[genre] = [] 
                resp[genre].Push(movie)
            end if
        end for
    end for

    'for each key in categories.keys(): '<- sort magic happens here
     '   resp[key] = categories[key]
    'end for
    return resp
end function