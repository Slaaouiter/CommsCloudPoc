import { LightningElement, api, track } from "lwc";
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent";
import { fetchCustomLabels, getUserProfile } from "vlocity_cmt/utility";
import componentTemplate from "./vnosDcOfferDetail.html";

export default class vnosDcOfferDetail extends vnosDcBaseComponent(
    LightningElement
) {
    @track _attribute;
    label;
    value;
    _translatedCustomLabels = {};

    @api
    set attribute(val) {
        if (val) {
            this._attribute = val;
            this.processAttribute();
        }
    }
    get attribute() {
        return this._attribute;
    }

    connectedCallback() {
        this.fetchTranslatedCustomLabels();
    }

    async fetchTranslatedCustomLabels() {
        const userProfile = await getUserProfile();

        const ALT_Label_Yes = "ALT_Label_Yes";
        const ALT_Label_No = "ALT_Label_No";

        try {
            this._translatedCustomLabels = await fetchCustomLabels(
                [
                    ALT_Label_Yes,
                    ALT_Label_No
                ],
                userProfile?.language || "pt_PT"
            )
        } catch (error) {
            console.error(
                "A problem occurred while fetching for the custom labels ==> the full error" +
                error
            )
        }
    }

    processAttribute() {
        this.label = this.attribute.label;
        if (this.attribute.inputType === 'dropdown') {
            if (this.attribute.userValues !== null) {
                let value = this.attribute.values.find(e => e.value === this.attribute.userValues);
                this.value = value.label;
            }
            else {
                this.value = null;
            }
        }
        else if (this.attribute.inputType === 'checkbox') {
            this.value = this.attribute.userValues ? this._translatedCustomLabels.ALT_Label_Yes : this._translatedCustomLabels.ALT_Label_No;
        }
        else {
            this.value = this.attribute.userValues;
        }
    }

    render() {
        return componentTemplate;
    }
}