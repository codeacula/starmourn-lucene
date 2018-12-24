Lucene.ui.sides.left = {}

setBorderLeft(Lucene.settings.border.left)

Lucene.ui.sides.left.container = Lucene.containers.container({
    name = "leftContainer",
    x = px(0), y = px(0),
    width = px(Lucene.settings.border.left), height = "100%"
})

Lucene.ui.sides.left.label = Lucene.containers.label({
    name = "leftLabel",
    x = px(0), y = px(0),
    width = "100%", height = "100%"
}, Lucene.ui.sides.left.container)
Lucene.ui.sides.left.label:setStyleSheet(Lucene.styles.leftLabel)
Lucene.ui.sides.left.label:setBackgroundImage(Lucene.getPath("background.jpg"))