{ inputs, outputs, lib, config, pkgs, ... }: {

  programs.firefox = {
    enable = true;
    # package = pkgs.firefox.override {
    #   cfg = {
    #     enableTridactylNative = true;
    #   };
    # };
    profiles.xin = {
      isDefault = true;
      userChrome = ''

/* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/navbar_tabs_oneliner.css made available under Mozilla Public License v. 2.0
See the above repository for updates as well as full license text. */

/* Make tabs and navbar appear side-by-side tabs on right */

/* Use page_action_buttons_on_hover.css to hide page-action-buttons to save more space for the address */

/*
urlbar_popup_full_width.css is VERY MUCH recommended for Firefox 71+ because of new urlbar popup
*/

:root[uidensity="compact"]{
  --tab-block-margin: 2px !important;
      }

/* Modify these to change relative widths or default height */
#navigator-toolbox{
  --uc-navigationbar-width: 40vw;
  --uc-toolbar-height: 40px;
  --uc-urlbar-min-width: 50vw; /* minimum width for opened urlbar */
}

#scrollbutton-up,
#scrollbutton-down{ border-block-width: 2px !important; }

/* Override for other densities */
:root[uidensity="compact"] #navigator-toolbox{ --uc-toolbar-height: 34px; }
:root[uidensity="touch"] #navigator-toolbox{ --uc-toolbar-height: 44px; }

/* prevent urlbar overflow on narrow windows */
/* Dependent on how many items are in navigation toolbar ADJUST AS NEEDED */
@media screen and (max-width: 1500px){
  #urlbar-container{ min-width:unset !important }
}

#TabsToolbar{
  margin-left: var(--uc-navigationbar-width);
  --tabs-navbar-shadow-size: 0px;
}
#tabbrowser-tabs{
  --tab-min-height: calc(var(--uc-toolbar-height) - 2 * var(--tab-block-margin,0px)) !important;
}

/* This isn't useful when tabs start in the middle of the window */

.titlebar-spacer[type="pre-tabs"]{ display: none }

#navigator-toolbox > #nav-bar{
  margin-right:calc(100vw - var(--uc-navigationbar-width));
  margin-top: calc(0px - var(--uc-toolbar-height));
}

/* Window drag space  */
:root[tabsintitlebar="true"] #nav-bar{ padding-left: 24px !important }

/* Rules specific to window controls on right layout */
@supports -moz-bool-pref("layout.css.osx-font-smoothing.enabled"){
  .titlebar-buttonbox-container{ position: fixed; display: block; left: 0px; z-index: 3; }
  :root[tabsintitlebar="true"] #nav-bar{ padding-left: 96px !important; padding-right: 0px !important; }
}

/* 1px margin on touch density causes tabs to be too high */
.tab-close-button{ margin-top: 0 !important }

/* Make opened urlbar overlay the toolbar */
#urlbar[open]:focus-within{ min-width: var(--uc-urlbar-min-width,none) !important; }

/* Hide dropdown placeholder */
#urlbar-container:not(:hover) .urlbar-history-dropmarker{ margin-inline-start: -28px; }

/* Fix customization view */
#customization-panelWrapper > .panel-arrowbox > .panel-arrow{ margin-inline-end: initial !important; }

/* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/toolbars_below_content.css made available under Mozilla Public License v. 2.0
See the above repository for updates as well as full license text. */

/* Moves tabs toolbar, bookmarks toolbar and main toolbar to the bottom of the window, and makes tabs be the bottom-most toolbar */

/* By default, menubar will stay on top with two options to select it's behavior - see below */

@-moz-document url(chrome://browser/content/browser.xhtml){

  /* Dummy variable to support versions 94-96, can be removed when 96 lands */
  :root{ --lwt-frame: var(--lwt-accent-color) }

  #titlebar{ -moz-appearance: none !important; }

  #navigator-toolbox > div{ display: contents }
  .global-notificationbox,
  #mainPopupSet,
  #browser,
  #customization-container,
  #tab-notification-deck{
    -moz-box-ordinal-group: 0
}

  /* Remove the next row if you want tabs to be the top-most row */

  #toolbar-menubar{
    position: fixed;
    display: flex;
    width: 100vw;
    top: 0px;
    -moz-window-dragging: drag;
  }
  /* Remove bottom border that won't do anything useful when at bottom of the window */
  #navigator-toolbox{ border-bottom: none !important; }

  #toolbar-menubar > spacer{ flex-grow: 1 }

  #urlbar[breakout][breakout-extend]{
    display: flex !important;
    flex-direction: column-reverse;
    bottom: -2px !important; /* Change to 3-5 px if using compact_urlbar_megabar.css depending on toolbar density */
    top: auto !important;
  }

  .urlbarView-body-inner{ border-top-style: none !important; }

  /* Yeah, removes window controls. Likely not wanted on bottom row  */
  #TabsToolbar > .titlebar-buttonbox-container{ display: none }
  #toolbar-menubar > .titlebar-buttonbox-container{ order: 1000 }

  /* Fix panels sizing */
  .panel-viewstack{ max-height: unset !important; }

  /* Fullscreen mode support */
  #navigator-toolbox[inFullscreen]{ margin-top: 0 !important }
  #navigator-toolbox[inFullscreen][style*="margin-top"]{ visibility: collapse }
  #fullscr-toggler{ bottom: 0; top: unset !important; }

  /* These three rules exist for compatibility with autohide_toolbox.css */
  #navigator-toolbox{ bottom: 0px; transform-origin: bottom }
  #main-window > body > box{ margin-top: 0 !important; }
  #toolbar-menubar{ z-index: 1; background-color: var(--lwt-frame,black); }

  #titlebar{ -moz-box-direction: normal; }

  /* Suppress Link Destination Overlay */
  #statuspanel[type="overLink"] {
    display: none !important;
  }

/* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_main_toolbar.css made available under Mozilla Public License v. 2.0
See the above repository for updates as well as full license text. */

/* Source file https://github.com/MrOtherGuy/firefox-csshacks/tree/master/chrome/autohide_toolbox.css made available under Mozilla Public License v. 2.0
See the above repository for updates as well as full license text. */

/* Hide the whole toolbar area unless urlbar is focused or cursor is over the toolbar */
/* Dimensions on non-Win10 OS probably needs to be adjusted */

/* Compatibility options for hide_tabs_toolbar.css and tabs_on_bottom.css at the end of this file */

:root{
  --uc-autohide-toolbox-delay: 200ms; /* Wait 0.1s before hiding toolbars */
  --uc-toolbox-rotation: 82deg;  /* This may need to be lower on mac - like 75 or so */
}

:root[sizemode="maximized"]{
  --uc-toolbox-rotation: 88.5deg;
      }

@media  (-moz-platform: windows),
  (-moz-os-version: windows-win7),
  (-moz-os-version: windows-win10){

  #navigator-toolbox:not(:-moz-lwtheme){ background-color: -moz-dialog !important; }
  }

:root[sizemode="fullscreen"],
#navigator-toolbox[inFullscreen]{ margin-top: 0 !important; }

#navigator-toolbox{
  position: fixed !important;
  display: block;
  background-color: var(--lwt-accent-color,black) !important;
  transition: transform 82ms linear, opacity 82ms linear !important;
  transition-delay: var(--uc-autohide-toolbox-delay) !important;
  transform-origin: top;
  transform: rotateX(var(--uc-toolbox-rotation));
  opacity: 0;
  line-height: 0;
  z-index: 1;
  pointer-events: none;
}


/* #mainPopupSet:hover ~ box > toolbox, */
/* Uncomment the above line to make toolbar visible if some popup is hovered */
#navigator-toolbox:hover,
#navigator-toolbox:focus-within{
  transition-delay: 33ms !important;
  transform: rotateX(0);
  opacity: 1;
}

#navigator-toolbox > *{ line-height: normal; pointer-events: auto }

#navigator-toolbox,
#navigator-toolbox > *{
  width: 100vw;
  -moz-appearance: none !important;
}

/* These two exist for oneliner compatibility */
#nav-bar{ width: var(--uc-navigationbar-width,100vw) }
#TabsToolbar{ width: calc(100vw - var(--uc-navigationbar-width,0px)) }

/* Don't apply transform before window has been fully created */
:root:not([sessionrestored]) #navigator-toolbox{ transform:none !important }

:root[customizing] #navigator-toolbox{
  position: relative !important;
  transform: none !important;
  opacity: 1 !important;
}

#navigator-toolbox[inFullscreen] > #PersonalToolbar,
#PersonalToolbar[collapsed="true"]{ display: none }

/* Uncomment this if tabs toolbar is hidden with hide_tabs_toolbar.css */
 /*#titlebar{ margin-bottom: -9px }*/

/* Uncomment the following for compatibility with tabs_on_bottom.css - this isn't well tested though */
/*
#navigator-toolbox{ flex-direction: column; display: flex; }
#titlebar{ order: 2 }
*/

'';
    };
  };
}
