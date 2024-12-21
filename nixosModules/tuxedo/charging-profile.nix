{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "charging-profile" ''
      #!/bin/sh

      tuxedo_available_profile_path="/sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profiles_available"
      tuxedo_path="/sys/devices/platform/tuxedo_keyboard/charging_profile/charging_profile"
      
      is_available() {
          if [[ ! -f "$tuxedo_path" || ! -f "$tuxedo_available_profile_path" ]]; then
              return 1
          fi
          available_profiles=$(cat "$tuxedo_available_profile_path" | tr -d '\n')
          if [[ "$available_profiles" != "high_capacity balanced stationary" ]]; then
              return 1
          fi
          return 0
      }
      
      set_threshold_limit() {
          local charging_mode=$1
          local profile
          case "$charging_mode" in
              ful)
                  profile="high_capacity"
                  ;;
              bal)
                  profile="balanced"
                  ;;
              max)
                  profile="stationary"
                  ;;
              *)
                  echo "Invalid charging mode: $charging_mode"
                  return 1
                  ;;
          esac
          echo "$profile" | sudo tee "$tuxedo_path" > /dev/null
          if verify_threshold "$profile"; then
              echo "Threshold applied successfully: $profile"
              return 0
          else
              echo "Failed to apply threshold: $profile"
              return 1
          fi
      }
      
      verify_threshold() {
          local expected_profile=$1
          local current_profile=$(cat "$tuxedo_path" | tr -d '\n')
          if [[ "$expected_profile" == "$current_profile" ]]; then
              return 0
          fi
          return 1
      }
      
      if ! is_available; then
          echo "Tuxedo keyboard charging profiles are not available."
          exit 1
      fi
      
      if [[ $# -eq 0 ]]; then
          echo "Usage: $0 <ful|bal|min>"
          exit 1
      fi
      
      set_threshold_limit "$1"
    '')
  ];
}
