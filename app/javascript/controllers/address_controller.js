import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["selectId", "detailsId"];

    connect() {
        console.log("AddressController connected");
    }

    updateDetails(event) {
        console.log('test')
        const addressId = this.selectIdTarget.value;

        $.ajax({
            url: `/addresses/${addressId}`,
            method: "GET",
            dataType: "json",
            success: (data) => {
                this.updateAddressDetails(data);
            },
            error: (error) => {
                console.error("Error fetching address details:", error);
            },
        });
    }

    updateAddressDetails(data) {
        const {name, is_default, genre, phone_number, remark, street_address, barangay, city, province} = data;

        this.detailsIdTarget.innerHTML = `
      <div class="d-flex justify-content-between">
        <div>Name:
          <span class="ms-2 fw-semibold">${name}</span>
        </div>

        <div>
          <span class="badge bg-info">${is_default ? "Default" : ""}</span>
          <span class="badge bg-primary">${genre}</span>
        </div>
      </div>
      <div>Phone Number:
        <span class="ms-2 fw-semibold">${phone_number}</span>
      </div>
      <div>Remark:
        <span class="ms-2 fw-semibold">${remark || "N/A"}</span>
      </div>
      <div>Address:
        <span class="ms-2 fw-semibold">${street_address}</span>
      </div>
      <div>
        <span class="fw-semibold">${barangay.name}, ${city.name} City, ${province.name}</span>
      </div>
    `;
    }
}