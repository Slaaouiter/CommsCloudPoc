import { LightningElement, api, track } from "lwc"
import { OmniscriptBaseMixin } from "vlocity_cmt/omniscriptBaseMixin"
import { fetchCustomLabels, getUserProfile } from "vlocity_cmt/utility"

import {
  findBestMatchProduct,
  getProductsThatHaveTheAttribute,
  convertStringToNumber,
} from "c/vnosOffersUtils"

export default class VnosLcOfferCard extends OmniscriptBaseMixin(
  LightningElement
) {
  @track
  _translatedCustomLabels = {}

  @track
  selectedProduct = {}

  @track
  products = []

  @track
  _offer

  hasLoyalty = false

  @api
  get offer() {
    return this._offer
  }

  set offer(offer) {
    this._offer = JSON.parse(JSON.stringify(offer))
    this.initialize()
  }

  connectedCallback() {
    this.fetchTranslatedCustomLabels()
    //this.excludeLoyalty()
  }

  async fetchTranslatedCustomLabels() {
    const userProfile = await getUserProfile()

    const ALT_Label_PerMonth = "ALT_Label_PerMonth"

    try {
      this._translatedCustomLabels = await fetchCustomLabels(
        [ALT_Label_PerMonth],
        userProfile?.language || "pt_PT"
      )
    } catch (error) {
      console.error(
        "A problem occurred while fetching for the custom labels ==> the full error" +
          error
      )
    }
  }

  get perMonthLabel() {
    return "/month";//this._translatedCustomLabels.ALT_Label_PerMonth
  }

  get isGrouped() {
    return this._offer.isGrouped
  }

  get initialAmountText() {
    return (
      "€" +
      this.selectedProduct.initialAmount +
      (this.selectedProduct.hasRecurringCharge ? this.perMonthLabel : "")
    )
  }

  get amountText() {
    return (
      "€" +
      this.selectedProduct.amount +
      (this.selectedProduct.hasRecurringCharge ? this.perMonthLabel : "")
    )
  }

  get isLoyaltyPossible() {
    return (
      this.selectedProduct?.promotions?.some(
        (promotion) => promotion.isLoyalty || promotion.isLoyaltyDependent
      ) || false
    )
  }

  initialize() {
    if (this.isGrouped) {
      this.products = this._offer.products
      this.selectedProduct = this.products[0]
    } else {
      this.selectedProduct = this._offer.product
    }
  }

  changeSelectedProduct(event) {
    if (event?.detail) {
      this.reInitializeSelectedProduct(event.detail)
      //this.reInitializeLoyalty()
    }
  }

  reInitializeSelectedProduct(attribute) {
    const productsWithTheSelectedAttribute = getProductsThatHaveTheAttribute(
      this.products,
      attribute
    )
    const onlyOneProductFoundWithTheSelectedAttribute =
      productsWithTheSelectedAttribute?.length === 1
    this.selectedProduct = onlyOneProductFoundWithTheSelectedAttribute
      ? productsWithTheSelectedAttribute[0]
      : findBestMatchProduct(
          productsWithTheSelectedAttribute,
          this.selectedProduct,
          attribute
        )
  }

  reInitializeLoyalty() {
    if (!this.isLoyaltyPossible && this.hasLoyalty) {
      this.hasLoyalty = false
      this.excludeLoyalty()
    }
  }

  selectProduct() {
    let eventDetail = {
      code: this.selectedProduct?.code,
      name: this.selectedProduct?.name,
      offerVariantCode:this.selectedProduct?.offerVariantCode,
      attribute: this.selectedProduct?.commercialAttributesComingFromMatrix,
      price: convertStringToNumber(this.selectedProduct?.amount),
      priceText: this.selectedProduct?.amountText,
      promotions: this.filterPromotionsForConfigureOfferStep(),
      initialAmountText: this.selectedProduct?.initialAmountText,
      initialAmount: convertStringToNumber(this.selectedProduct?.initialAmount),
    }
    let event = new CustomEvent("selectoffer", {
      detail: eventDetail,
    })
    this.dispatchEvent(event)
  }

  filterPromotionsForConfigureOfferStep() {
    if (this.hasLoyalty) {
      return this.selectedProduct?.promotions?.filter((promotion) => !promotion.isLoyaltyExcluded) || []
    }
    
    return this.selectedProduct?.promotions?.filter((promotion) => !promotion.isLoyalty && !promotion.isLoyaltyDependent) || [];
  }

  handleLoyaltyOptionChange(event) {
    if (event) {
      const withLoyalty = event.detail
      if (withLoyalty) {
        this.includeLoyalty()
      } else {
        this.excludeLoyalty()
      }
    }
  }

  includeLoyalty() {
    this.hasLoyalty = true
    if (this.isGrouped) {
      this.includeLoyaltyForGroupedProducts()
    } else {
      this.includeLoyaltyForProduct(this._offer.product)
    }
  }

  includeLoyaltyForGroupedProducts() {
    this._offer?.products?.forEach((product) => {
      this.includeLoyaltyForProduct(product)
    })
  }

  includeLoyaltyForProduct(product) {
    if (product) {
      this.includeLoyaltyPromotions(product)
      this.recalculateTheAmount(product)
    }
  }

  includeLoyaltyPromotions(product) {
    if (product) {
      const promotionsRelatedToLoyalty = product.promotions?.filter(
        (promotion) => !promotion.isLoyaltyExcluded
      )
      this.updateAutoAppliedPromotionsAtBrowseOffer(
        product,
        promotionsRelatedToLoyalty
      )
      this.updateAutoAppliedPromotionsAtTop(product, promotionsRelatedToLoyalty)
      this.updateAutoAppliedPromotionsAtCenter(
        product,
        promotionsRelatedToLoyalty
      )
      this.updateAutoAppliedPromotionsBelowFirstAttribute(
        product,
        promotionsRelatedToLoyalty
      )
    }
  }

  excludeLoyalty() {
    this.hasLoyalty = false
    if (this.isGrouped) {
      this.excludeLoyaltyForGroupedProducts()
    } else {
      this.excludeLoyaltyForProduct(this._offer.product)
    }
  }

  excludeLoyaltyForGroupedProducts() {
    this._offer.products.forEach((product) => {
      this.excludeLoyaltyForProduct(product)
    })
  }

  excludeLoyaltyForProduct(product) {
    if (product) {
      this.excludeLoyaltyPromotions(product)
      this.recalculateTheAmount(product)
    }
  }

  excludeLoyaltyPromotions(product) {
    if (product) {
      const promotionsUnrelatedToLoyalty = product.promotions?.filter(
        (promotion) => !promotion.isLoyalty && !promotion.isLoyaltyDependent
      )
      if (promotionsUnrelatedToLoyalty) {
        this.updateAutoAppliedPromotionsAtBrowseOffer(
          product,
          promotionsUnrelatedToLoyalty
        )
        this.updateAutoAppliedPromotionsAtTop(
          product,
          promotionsUnrelatedToLoyalty
        )
        this.updateAutoAppliedPromotionsAtCenter(
          product,
          promotionsUnrelatedToLoyalty
        )
        this.updateAutoAppliedPromotionsBelowFirstAttribute(
          product,
          promotionsUnrelatedToLoyalty
        )
      }
    }
  }

  updateAutoAppliedPromotionsAtBrowseOffer(product, promotions) {
    if (product && promotions) {
      product.autoAppliedPromotionsAtBrowseOffer = promotions.filter(
        (promotion) =>
          promotion.autoAppliedMoment?.replace(/\s/g, "")?.toLowerCase().includes("atofferbrowse")
      )
    }
  }

  updateAutoAppliedPromotionsAtCenter(product, promotions) {
    if (product && promotions) {
      product.autoAppliedPromotions.Center = promotions.filter(
        (promotion) =>
          promotion.position?.replace(/\s/g, "")?.toLowerCase().includes("center")
      )
    }
  }

  updateAutoAppliedPromotionsAtTop(product, promotions) {
    if (product && promotions) {
      product.autoAppliedPromotions.Top = promotions.filter(
        (promotion) =>
          promotion.position?.replace(/\s/g, "")?.toLowerCase()?.includes("top")
      )
    }
  }

  updateAutoAppliedPromotionsBelowFirstAttribute(product, promotions) {
    if (product && promotions) {
      product.autoAppliedPromotions.BelowFirstAttribute = promotions.filter(
        (promotion) =>
          promotion.position?.replace(/\s/g, "")?.toLowerCase().includes("belowfirstattribute")
      )
    }
  }

  recalculateTheAmount(product) {
    if (product) {
      let amount = convertStringToNumber(product.initialAmount)

      product.autoAppliedPromotionsAtBrowseOffer.forEach((promotion) => {
        amount += convertStringToNumber(promotion.chargeAmount)
      })
      product.amount = amount.toFixed(2)
    }
  }
}