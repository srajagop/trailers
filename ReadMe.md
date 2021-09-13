## Sample Roku TV channel

A sample roku TV channel implementation based pretty much off the roku developer portal build a channel example
https://developer.roku.com/en-gb/videos/courses/rsg/overview.md

### DEV notes

Set Environment variables and use vscode plugin for development saves a ton of time

% export ROKU_DEV_TARGET=xxx.xxx.xxx.xxx <br/>
% export DEVPASSWORD=xxxx

app.mk has a bug in macOs. Ping arguments doesnt work as expected modify line 138 in app.mk to 
https://github.com/srajagop/trailers/blob/main/app.mk#L138

### TODO
- [ ] Sidebar menu
- [ ] Scene Routing / Stacking refactor
- [ ] Lazy Loading
- [ ] Authorization
