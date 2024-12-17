import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["ticketCount"]

    connect() {
        console.log("TicketController connected");
    }

    increment() {
        const ticketCountValue = parseInt(this.ticketCountTarget.value, 10);
        this.ticketCountTarget.value = ticketCountValue + 1;
    }

    decrement() {
        const ticketCountValue = parseInt(this.ticketCountTarget.value, 10);

        if (ticketCountValue > 1) {
            this.ticketCountTarget.value = ticketCountValue - 1;
        }
    }
}