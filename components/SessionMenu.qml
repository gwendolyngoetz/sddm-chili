/*
 *   Copyright 2018 Marian Alexander Arlt <marianarlt@icloud.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 3 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */

import QtQuick
import QtQuick.Controls

ToolButton {
    id: root

    property int currentIndex: -1
    property int rootFontSize
    property string rootFontColor

    visible: menu.count > 1

    opacity: root.activeFocus ? 1 : 0.5

    background: Rectangle {
        color: "transparent"
    }

    contentItem: Label {
        id: buttonLabel
        color: rootFontColor
        font.pointSize: rootFontSize
        renderType: Text.QtRendering
        font.underline: root.activeFocus
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: {
            // instantiator.count is read so the binding re-evaluates once items exist
            var item = currentIndex >= 0 && currentIndex < instantiator.count
                ? instantiator.objectAt(currentIndex) : null
            return item ? item.text : ""
        }
    }

    Component.onCompleted: {
        currentIndex = sessionModel.lastIndex
    }

    onClicked: menu.open()

    Menu {
        id: menu
        // Button sits in the footer, so open upwards
        y: -menu.height

        Instantiator {
            id: instantiator
            model: sessionModel
            onObjectAdded: (index, object) => menu.insertItem(index, object)
            onObjectRemoved: (index, object) => menu.removeItem(object)
            delegate: MenuItem {
                text: model.name
                onTriggered: {
                    root.currentIndex = model.index
                }
            }
        }
    }
}
