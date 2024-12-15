import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["inviteUrlId"]

    copy() {
        const textArea = document.createElement("textarea");
        textArea.value = this.inviteUrlIdTarget.textContent;
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        try {
            document.execCommand('copy');
        } catch (err) {
            console.error('Unable to copy to clipboard', err);
        }
        document.body.removeChild(textArea);
    }
}