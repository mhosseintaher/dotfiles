#!/bin/bash

# Runs on input_source_changed, which sketchybarrc binds to macOS's
# AppleSelectedInputSourcesChangedNotification, so there is no polling.

source "$CONFIG_DIR/colors.sh"

ID=$(defaults read com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID 2>/dev/null)

case "$ID" in
  *Persian*|*Farsi*)                       LANG_CODE="FA" ;;
  *.US|*.ABC|*USExtended*|*USInternational*|*British*|*Australian*|*Canadian*|*Irish*|*Colemak*|*Dvorak*)
                                           LANG_CODE="EN" ;;
  *Arabic*)                                LANG_CODE="AR" ;;
  *German*)                                LANG_CODE="DE" ;;
  *French*)                                LANG_CODE="FR" ;;
  *Spanish*)                               LANG_CODE="ES" ;;
  *Italian*)                               LANG_CODE="IT" ;;
  *Portuguese*|*Brazilian*)                LANG_CODE="PT" ;;
  *Russian*)                               LANG_CODE="RU" ;;
  *Japanese*|*Kotoeri*)                    LANG_CODE="JP" ;;
  *Korean*)                                LANG_CODE="KR" ;;
  *Chinese*|*SCIM*|*TCIM*)                 LANG_CODE="CN" ;;
  "")                                      LANG_CODE="EN" ;;
  *) # e.g. com.apple.keylayout.Swedish-Pro -> SWE
     LANG_CODE=$(printf '%.3s' "${ID##*.}" | tr '[:lower:]' '[:upper:]') ;;
esac

case "$LANG_CODE" in
  EN) COLOR="$BLUE" ;;
  ES) COLOR="$ORANGE" ;;
  FA) COLOR="$MAGENTA" ;;
  *)  COLOR="$WHITE" ;;
esac

sketchybar --set "$NAME" label="$LANG_CODE" \
                         icon.color="$COLOR" \
                         label.color="$COLOR"
