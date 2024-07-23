import tmux from "./tmux"
import lowBattery from "./battery"
import notifications from "./notifications"

export default function init() {
    try {
        tmux()
        lowBattery()
        notifications()
    } catch (error) {
        logError(error)
    }
}
