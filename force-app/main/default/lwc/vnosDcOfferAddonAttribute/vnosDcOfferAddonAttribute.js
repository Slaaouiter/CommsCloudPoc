import { LightningElement, api, track } from "lwc"
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent"
import componentTemplate from "./vnosDcOfferAddonAttribute.html"

export default class vnosDcOfferAddonAttribute extends vnosDcBaseComponent(
  LightningElement
) {
  @track _attribute
  digitalCommerceSDK = null

  connectedCallback() {
    this.getSDKInstance()
  }

  getSDKInstance() {
    this.getDigitalCommerceSDK()
      .then((sdkInstance) => {
        if (sdkInstance) {
          this.digitalCommerceSDK = sdkInstance
        }
      })
      .catch((e) => {
        console.log("Error in getting SDK instance ", e)
      })
  }

  @api
  offerCode

  @api
  set attribute(val) {
    if (val) {
      this._attribute = JSON.parse(JSON.stringify(val))
    }
  }
  get attribute() {
    return this._attribute
  }

  get isDropdown() {
    return this.attribute.inputType === "dropdown"
  }

  get readonly() {
    return this.attribute.values[0].readonly
  }

  handleChange(event) {
    let attributeCode = this.attribute.code
    let selectedValue = event.target.value
    const offerCode = this.offerCode
    const details = { attributeCode, selectedValue, offerCode }
    // Dispatches the event.
    this.triggerConfigureChildOfferEvent(details)
  }

  triggerConfigureChildOfferEvent(details) {
    this.debounce(
      500,
      (offer) => {
        this.digitalCommerceSDK &&
          this.digitalCommerceSDK.fire(
            "vlocity-dc-configure-child-offers",
            "result",
            offer
          )
      },
      details
    )
  }

  render() {
    return componentTemplate
  }
}