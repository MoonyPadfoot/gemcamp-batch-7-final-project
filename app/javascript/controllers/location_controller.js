import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ['selectedRegionId', 'selectedProvinceId', 'selectedCityId', 'selectBarangayId']

    updateAddress() {
        let region = this.selectedRegionIdTarget
        let province = this.selectedProvinceIdTarget
        let city = this.selectedCityIdTarget
        let barangay = this.selectBarangayIdTarget

        let selectedRegionOption = region.options[region.selectedIndex];
        let selectedRegion = $(selectedRegionOption).text();

        let selectedProvinceOption = province.options[province.selectedIndex];
        let selectedProvince = $(selectedProvinceOption).text();

        let selectedCityOption = city.options[city.selectedIndex];
        let selectedCity = $(selectedCityOption).text();

        let selectedBarangayOption = barangay.options[barangay.selectedIndex];
        let selectedBarangay = $(selectedBarangayOption).text();

        if (selectedRegion !== 'Please select region')
            address.value = selectedRegion

        if (selectedProvince !== 'Please select province')
            address.value += ', ' + selectedProvince

        if (selectedCity !== 'Please select city')
            address.value += ', ' + selectedCity

        if (selectedBarangay !== 'Please select barangay')
            address.value += ', ' + selectedBarangay
    }

    fetchProvinces() {
        let target = this.selectedProvinceIdTarget
        let city = this.selectedCityIdTarget
        let barangay = this.selectBarangayIdTarget
        $(target).empty();
        $(city).empty();
        $(barangay).empty();

        let promptOption = document.createElement('option');
        promptOption.value = "";
        promptOption.text = "Please select province";
        target.appendChild(promptOption);

        let promptOption2 = document.createElement('option');
        promptOption2.value = "";
        promptOption2.text = "Please select city";
        city.appendChild(promptOption2);

        let promptOption3 = document.createElement('option');
        promptOption3.value = "";
        promptOption3.text = "Please select barangay";
        barangay.appendChild(promptOption3);

        $.ajax({
            type: 'GET',
            url: '/api/v1/regions/' + this.selectedRegionIdTarget.value + '/provinces',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }

    fetchCities() {
        let target = this.selectedCityIdTarget
        let barangay = this.selectBarangayIdTarget
        $(target).empty();
        $(barangay).empty()

        let promptOption = document.createElement('option');
        promptOption.value = "";
        promptOption.text = "Please select city";
        target.appendChild(promptOption);

        let promptOption2 = document.createElement('option');
        promptOption2.value = "";
        promptOption2.text = "Please select barangay";
        barangay.appendChild(promptOption2);

        $.ajax({
            type: 'GET',
            url: '/api/v1/provinces/' + this.selectedProvinceIdTarget.value + '/cities',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }

    fetchBarangays() {
        let target = this.selectBarangayIdTarget
        $(target).empty();

        let promptOption = document.createElement('option');
        promptOption.value = "";
        promptOption.text = "Please select barangay";
        target.appendChild(promptOption);

        $.ajax({
            type: 'GET',
            url: '/api/v1/cities/' + this.selectedCityIdTarget.value + '/barangays',
            dataType: 'json',
            success: (response) => {
                console.log(response)
                $.each(response, function (index, record) {
                    let option = document.createElement('option')
                    option.value = record.id
                    option.text = record.name
                    target.appendChild(option)
                })
            }
        })
    }
}