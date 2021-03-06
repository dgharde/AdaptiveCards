import QtQuick 2.15
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
Rectangle{
id:adaptiveCard
readonly property int margins:12
implicitHeight:adaptiveCardLayout.implicitHeight
Layout.fillWidth:true
readonly property string bgColor:'#FFFFFF'
color:bgColor
signal buttonClicked(var title, var type, var data)
function generateStretchHeight(childrens,minHeight){
var n = childrens.length
var implicitHt = 0;
var stretchCount = 0;
var stretchMinHeight = 0;
for(var i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator !== 'undefined')
{
implicitHt += childrens[i].height;
stretchMinHeight += childrens[i].height;
}
else
{
implicitHt += childrens[i].implicitHeight;
if(typeof childrens[i].stretch !== 'undefined')
{
stretchCount++;
}
else
{
stretchMinHeight += childrens[i].implicitHeight;
}
}
}
stretchMinHeight = (minHeight - stretchMinHeight)/stretchCount
for(i=0;(i<childrens.length);i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined' && typeof childrens[i].minHeight !== 'undefined')
{
childrens[i].minHeight = Math.max(childrens[i].minHeight,stretchMinHeight)
}
}
}
if(stretchCount > 0 && implicitHt < minHeight)
{
var stretctHeight = (minHeight - implicitHt)/stretchCount
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined')
{
childrens[i].height = childrens[i].implicitHeight + stretctHeight
}
}
}
}
else
{
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(typeof childrens[i].stretch !== 'undefined')
{
childrens[i].height = childrens[i].implicitHeight
}
}
}
}
}
function generateStretchWidth(childrens,width){
var implicitWid = 0
var autoWid = 0
var autoCount = 0
var weightSum = 0
var stretchCount = 0
var weightPresent = 0
for(var i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator !== 'undefined')
{
implicitWid += childrens[i].width
}
else
{
if(childrens[i].widthProperty.endsWith("px"))
{
childrens[i].width = parseInt(childrens[i].widthProperty.slice(0,-2))
implicitWid += childrens[i].width
}
else
{
if(childrens[i].widthProperty === "auto")
{
autoCount++
}
else if(childrens[i].widthProperty === "stretch")
{
stretchCount++
implicitWid += 50;
}
else
{
weightPresent = 1
weightSum += parseInt(childrens[i].widthProperty)
}
}
}
}
autoWid = (width - implicitWid)/(weightPresent + autoCount)
var flags = new Array(childrens.length).fill(0)
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === "auto")
{
if(childrens[i].minWidth < autoWid)
{
childrens[i].width = childrens[i].minWidth
implicitWid += childrens[i].width
flags[i] = 1;
autoCount--;
autoWid = (width - implicitWid)/(weightPresent + autoCount)
}
}
}
}
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === "auto")
{
if(flags[i] === 0)
{
childrens[i].width = autoWid
implicitWid += childrens[i].width
}
}
else if(childrens[i].widthProperty !== "stretch" && !childrens[i].widthProperty.endsWith("px"))
{
if(weightSum !== 0)
{
childrens[i].width = ((parseInt(childrens[i].widthProperty)/weightSum) * autoWid)
implicitWid += childrens[i].width
}
}
}
}
var stretchWidth = (width - implicitWid)/stretchCount
for(i=0;i<childrens.length;i++)
{
if(typeof childrens[i].seperator === 'undefined')
{
if(childrens[i].widthProperty === 'stretch')
{
childrens[i].width = 50+stretchWidth
}
}
}
}
function getMinWidth(childrens){
var min = 0
for(var j =0;j<childrens.length;j++)
{
if(typeof childrens[j].minWidth === 'undefined')
{
min = Math.max(min,Math.ceil(childrens[j].implicitWidth))
}
else
{
min = Math.max(min,Math.ceil(childrens[j].minWidth))
}
}
return min
}
function getMinWidthActionSet(childrens,spacing){
var min = 0
for(var j =0;j<childrens.length;j++)
{
min += Math.ceil(childrens[j].implicitWidth)
}
min += ((childrens.length - 1)*spacing)
return min
}
function getMinWidthFactSet(childrens, spacing){
var min = 0
for(var j=0;j<childrens.length;j+=2)
{
min = Math.max(min,childrens[j].implicitWidth + childrens[j+1].implicitWidth + spacing)
}
return min;
}
ColumnLayout{
id:adaptiveCardLayout
width:parent.width
Rectangle{
id:adaptiveCardRectangle
color:'transparent'
Layout.topMargin:margins
Layout.bottomMargin:margins
Layout.leftMargin:margins
Layout.rightMargin:margins
Layout.fillWidth:true
Layout.preferredHeight:bodyLayout.height
Layout.minimumHeight:1
Column{
id:bodyLayout
width:parent.width
onImplicitHeightChanged:{adaptiveCard.generateStretchHeight(children,-24)}
onImplicitWidthChanged:{adaptiveCard.generateStretchHeight(children,-24)}
Rectangle{
id:i1
implicitHeight:height
readonly property string bgColor:Qt.rgba(170, 187, 204, 1.00)
width:parent.width != 0 ? Math.min(10, parent.width) : 10
height:10
implicitWidth:10
color:bgColor
Image{
id:i1_img
readonly property bool isImage:true
cache:false
source:"https://picsum.photos/300/200?image=800"
anchors.fill:parent
visible:parent.visible
}
MouseArea{
anchors.fill:parent
acceptedButtons:Qt.LeftButton
hoverEnabled:true
onEntered:{i1.color = '#F2F4F5';}
onExited:{i1.color = Qt.rgba(170, 187, 204, 1.00);}
onClicked:{
adaptiveCard.buttonClicked("Hello", "Action.OpenUrl", "https://www.cisco.com/");
console.log("https://www.cisco.com/");
}
}
}
Rectangle{
readonly property bool seperator:true
width:parent.width
height:4
color:"transparent"
visible:false
}
Rectangle{
id:i2
implicitHeight:height
readonly property string bgColor:'transparent'
visible:false
width:parent.width
height:i2_img.implicitHeight / i2_img.implicitWidth * width
implicitWidth:i2_img.implicitWidth
color:bgColor
Image{
id:i2_img
readonly property bool isImage:true
cache:false
source:"https://picsum.photos/200/200?image=100"
anchors.fill:parent
visible:parent.visible
}
MouseArea{
anchors.fill:parent
acceptedButtons:Qt.LeftButton
hoverEnabled:true
onEntered:{i2.color = '#F2F4F5';}
onExited:{i2.color = 'transparent';}
onClicked:{
var paramJson = {};
var parmStr = "{\"h\":\"x\"}";
paramJson = JSON.parse(parmStr);
var paramslist = JSON.stringify(paramJson);
adaptiveCard.buttonClicked("submit", "Action.Submit", paramslist);
console.log(paramslist);
}

}
}
Rectangle{
readonly property bool seperator:true
width:parent.width
height:12
color:"transparent"
visible:true
}
Rectangle{
id:i3
implicitHeight:height
readonly property string bgColor:'transparent'
readonly property bool stretch:true
width:parent.width
height:i3_img.implicitHeight / i3_img.implicitWidth * width
implicitWidth:width
color:bgColor
anchors.horizontalCenter:parent.horizontalCenter
Image{
id:i3_img
readonly property bool isImage:true
cache:false
source:"https://picsum.photos/300/200?image=200"
anchors.fill:parent
visible:parent.visible
}
MouseArea{
anchors.fill:parent
acceptedButtons:Qt.LeftButton
hoverEnabled:true
onEntered:{i3.color = '#F2F4F5';}
onExited:{i3.color = 'transparent';}
onClicked:{
}
}
}
Rectangle{
readonly property bool seperator:true
width:parent.width
height:12
color:"transparent"
visible:true
}
Rectangle{
id:i4
implicitHeight:height
readonly property string bgColor:'transparent'
width:160
height:i4_img.implicitHeight / i4_img.implicitWidth * width
implicitWidth:width
color:bgColor
Image{
id:i4_img
readonly property bool isImage:true
cache:false
source:"https://picsum.photos/300/200?image=301"
anchors.fill:parent
visible:parent.visible
}
}
}
}
}
}
