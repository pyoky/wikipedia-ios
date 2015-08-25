var utilities = require("./utilities");

function getSectionHeadersArray(){
    var nodeList = document.querySelectorAll('h1.section_heading');
    var nodeArray = Array.prototype.slice.call(nodeList);
    nodeArray = nodeArray.map(function(n){
        return {
            anchor:n.getAttribute('id'),
            sectionId:n.getAttribute('sectionId'),
            text:n.textContent
        };
    });
    return nodeArray;
}

function getSectionHeaderLocationsArray(){
    var nodeList = document.querySelectorAll('h1.section_heading');
    var nodeArray = Array.prototype.slice.call(nodeList);
    nodeArray = nodeArray.map(function(n){
        return n.getBoundingClientRect().top;
    });
    return nodeArray;
}

function getSectionHeaderForId(id){
    var sectionHeadingParent = utilities.findClosest(document.getElementById(id), 'div[id^="section_heading_and_content_block_"]');
    var sectionHeading = sectionHeadingParent.querySelector('h1.section_heading');
    return sectionHeading;
}

exports.getSectionHeaderForId = getSectionHeaderForId;
global.getSectionHeadersArray = getSectionHeadersArray;
global.getSectionHeaderLocationsArray = getSectionHeaderLocationsArray;
