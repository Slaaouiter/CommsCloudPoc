import { LightningElement, api, track } from "lwc"
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent"
import componentTemplate from "./vnosDcOfferDetails.html"
import { cloneDeep } from "vlocity_cmt/lodash"

export default class vnosDcOfferDetails extends vnosDcBaseComponent(
  LightningElement
) {
  @track _selectedProduct
  @track _catalogCode = ""
  @track _offerCode = ""
  @track loading = false
  @track offer
  @track offerAttributes = []
  digitalCommerceSDK = null

  @track
  _currentOffer = ""

  @api
  set catalogCode(val) {
    if (val) {
      this._catalogCode = val
    }
  }
  get catalogCode() {
    return this._catalogCode
  }

  @api
  set offerCode(val) {
    if (val) {
      this._offerCode = val
    }
  }
  get offerCode() {
    return this._offerCode
  }

  @api
  set currentOffer(val) {
    if (val) {
      this._currentOffer = val
      this.offer = cloneDeep(val)
      this.processAttributes()
    }
  }
  get currentOffer() {
    return this._currentOffer
  }

  @api
  set selectedProduct(val) {
    if (val) {
      this._selectedProduct = Object.assign({}, val)
    }
  }
  get selectedProduct() {
    return this._selectedProduct
  }

  getOffer() {
    if (!this.currentOffer) {
      this.loading = true
      let input = Object.assign(this.digitalCommerceSDK.createGetOfferInput(), {
        catalogCode: this.catalogCode,
        offerCode: this.offerCode,
      })
      this.digitalCommerceSDK
        .getOffer(input)
        .then((offerResponse) => {
          if (offerResponse) {
            this.offer = Object.assign({}, offerResponse)
            this.processAttributes()
          }
          this.loading = false
        })
        .catch((e) => {
          this.loading = false
          this.showToast("Error", "Fail to load Offer", "error", this)
        })
    } else {
      this.offer = cloneDeep(this.currentOffer)
      this.processAttributes()
      this.loading = false
    }
  }

  processAttributes() {
    this.offer.attributes =
      (this.offer &&
        this.offer.attributes &&
        Object.values(this.offer.attributes)) ||
      []
    this.offer.attributes.forEach((attributes) => {
      attributes.forEach((attribute) => {
        attribute[attribute.inputType] = true
      })
    })
  }

  connectedCallback() {
    this.getSDKInstance()
    if (!this.currentOffer) {
      if (!this.catalogCode && !this.offerCode) {
        this.showToast(
          "Error",
          "Missing offerCode and catalogCode params",
          "error",
          this
        )
      }
    }
  }

  getSDKInstance() {
    if (!this.currentOffer) {
      if (!this.offerCode || !this.catalogCode) {
        return
      }
    }
    if (this.digitalCommerceSDK) {
      this.getOffer()
    } else {
      this.loading = true
      this.getDigitalCommerceSDK()
        .then((sdkInstance) => {
          this.digitalCommerceSDK = sdkInstance
          this.getOffer()
        })
        .catch((e) => {
          this.digitalCommerceSDK = null
          this.loading = false
          console.error("Error in getting SDK instance ", e)
        })
    }
  }

  render() {
    return componentTemplate
  }
}