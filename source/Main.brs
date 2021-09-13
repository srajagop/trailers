'*************************************************************
'** Hello World example 
'** Copyright (c) 2015 Roku, Inc.  All rights reserved.
'** Use of the Roku Platform is subject to the Roku SDK Licence Agreement:
'** https://docs.roku.com/doc/developersdk/en-us
'*************************************************************

sub Main()
    print "in showChannelSGScreen"
    ShowChannelRSGScreen()
end sub

sub ShowChannelRSGScreen()
    print "in showChannelSGScreen"
    ' The roSGScreen object is a SceneGraph canvas that displays the contents of a Scene node instance
    screen = CreateObject("roSGScreen")
    ' message port is the place where events are sent
    ' m.port makes it accessible to the whole main scene component
    m.port = CreateObject("roMessagePort")
    ' sets the message port which will be used for events from the screen
    screen.SetMessagePort(m.port)
    ' every screen object must have a Scene node, or a node that derives from the Scene node
    scene = screen.CreateScene("MainScene")
    screen.Show() ' Init method in MainScene.brs is invoked

    ' event loop
    while(true)
        ' waiting for events from screen
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.IsScreenClosed() then return
        end if
    end while
end sub
