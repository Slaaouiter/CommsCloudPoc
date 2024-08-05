import { api, LightningElement, track } from "lwc"
import {
  getAttribute,
  hasAttribute,
  getOptionsSize,
  getNdsSize,
  isPriceDifferenceZero,
  isSelectedProduct,
  getPriceDifferenceTextBetweenProducts,
  findProductWithSameInputAttributesAsSelectedProduct
} from "c/vnosOffersUtils"

export default class VnosOfferCardOptions extends LightningElement {
  @track
  options = []

  @api
  attribute

  @api
  products

  @track
  _selectedProduct

  _numberOfOptions = 1

  @api
  get selectedProduct() {
    return this._selectedProduct
  }

  set selectedProduct(selectedProduct) {
    this._selectedProduct = selectedProduct
    this.initializeOptions()
  }
  

  initializeOptions() {
    if (this.attribute && this.options && this._selectedProduct) {
        this._numberOfOptions = getOptionsSize(this.products, this.attribute);
        
        const optionsMap = new Map();

        for (const product of this.products) {
            const option = this.initializeOption(product);
            //TODO Technical debt => we should not filter by value 'Unica'. It should be more generic
            if (option && option.value && !optionsMap.has(option.value) && option.value !== 'Unica') {
                optionsMap.set(option.value, option);
            }
        }

        this.options = Array.from(optionsMap.values());
    }
}


  initializeOption(product) {
    let attribute = getAttribute(product, this.attribute.code)

    if (!attribute) {
      return undefined
    }

    let option = {}
    option.value = attribute.value
    option.priceDifferenceWithSelectedProduct =
      getPriceDifferenceTextBetweenProducts(product, this._selectedProduct)
    option.style = this.getStyle(option)
    option.priceStyle = this.getPriceStyle(product)
    return option
  }

  getPriceStyle(product) {
    return isPriceDifferenceZero(product, this._selectedProduct)
      ? isSelectedProduct(product, this._selectedProduct)
        ? "vnos-card-option-price-selected"
        : "vnos-card-option-price-zero-different-offer"
      : "vnos-card-option-price"
  }

  getStyle(option) {
    return hasAttribute(
      this._selectedProduct,
      this.attribute.code,
      option.value
    )
      ? getNdsSize(this._numberOfOptions) +
          " vnos-radio-item vnos-radio-item-selected"
      : getNdsSize(this._numberOfOptions) + " vnos-radio-item"
  }

  selectOption(event) {
    if (this.hasMultipleOptions) {
      let attributeValue = event?.currentTarget?.dataset?.key
      let eventDetail = {
        code: this.attribute.code,
        value: attributeValue,
      }

      let customEvent = new CustomEvent("selectoption", {
        detail: eventDetail,
      })

      this.dispatchEvent(customEvent)
    }
  }

  get hasMultipleOptions() {
    return this._numberOfOptions !== 1
  }
}