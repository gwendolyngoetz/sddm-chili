/*
 *   Copyright 2018 Marian Arlt <marianarlt@icloud.com>
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
import QtQuick.Effects

FocusScope {
    id: backgroundComponent

    property alias imageSource: backgroundImage.source
    property bool configBlur: (config.blur !== undefined) && (config.blur == "true")

    Image {
        id: backgroundImage

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        clip: true
        focus: true
        smooth: true

        onStatusChanged: {
            if (status === Image.Error) {
                console.log("ERROR: Failed to load background:", source)
            } else if (status === Image.Ready) {
                console.log("SUCCESS: Background loaded:", source)
            }
        }
    }

    ShaderEffectSource {
        id: sourceItem
        sourceItem: backgroundImage
        anchors.fill: parent
        visible: false
        // Important: extend the source bounds for blur sampling
        sourceRect: Qt.rect(-20, -20, width + 40, height + 40)
    }

    MultiEffect {
        id: backgroundBlur
        anchors.fill: parent
        source: sourceItem
        visible: configBlur

        blurEnabled: configBlur
        blurMax: configBlur ? (config.recursiveBlurRadius || 64) : 0
        blur: configBlur ? 1.0 : 0.0
    }

    MouseArea {
        anchors.fill: parent
        onClicked: container.focus = true
    }
}
