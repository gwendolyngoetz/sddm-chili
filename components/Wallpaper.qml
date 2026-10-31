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
    property bool configBlur: config.blur == "true"
    // MultiEffect caps blurMax at 64
    readonly property int blurRadius: Math.min(64, parseInt(config.recursiveBlurRadius) || 32)

    Image {
        id: backgroundImage

        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop

        clip: true
        focus: true
        smooth: true

        onStatusChanged: {
            if (status === Image.Error) {
                console.warn("chili: failed to load background", source)
            }
        }
    }

    // Replaces QtGraphicalEffects.RecursiveBlur. Padding is off so the blur
    // clamps to the image edges instead of fading to transparent at the screen border.
    MultiEffect {
        id: backgroundBlur

        anchors.fill: backgroundImage
        source: backgroundImage
        visible: configBlur

        autoPaddingEnabled: false
        blurEnabled: configBlur
        blurMax: blurRadius
        blur: 1.0
    }

    MouseArea {
        anchors.fill: parent
        // Clicking the wallpaper returns focus to the password field instead of parking
        // it on a layout item where keyboard input would go nowhere.
        onClicked: userListComponent.focusPasswordField()
    }
}
