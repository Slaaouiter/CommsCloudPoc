import { LightningElement, api, track } from "lwc"
import componentTemplate from "./vnosDcConfigureOffer.html"
import { vnosDcBaseComponent } from "c/vnosDcBaseComponent"

export default class vnosDcConfigureOffer extends vnosDcBaseComponent(
  LightningElement
) {
  _CONSTANTS = {
    mergeFields: {
      processTagInformation: "%ProcessTagInformation%",
      deliveryMethod: "%Select_BillDeliveryMethod_BP%",
      paymentMethod: "%Radio_DirectDebitOrATM_BP%",
      isNewCustomer: "%isNewCustomer%",
      selectedBillingAcocunt:
        "%Step_CreateNewBillingAccount_BP:Blck_ExistingAccount_BP:LWC_BillingAccountSelection_BPNSPI:selectedBillingAccount%",
      existingOrNewBA: "%Radio_ExistingOrNewBA_BP%",
    },
    events: {
      saveChildOffers: "vlocity-dc-save-child-offers",
      configureChildOffers: "vlocity-dc-configure-child-offers",
      addToCart: "vlocity-dc-add-to-cart",
    },
    key: "ConfigureOffer",
    electronicInvoiceDeliveryMethod: "BDM_ElectronicInvoice",
    paperBillingDeliveryMethod: "BDM_PaperBilling",
    atmPaymentMethod: "ATM",
    directDebitPaymentMethod: "DirectDebit",
    existing: "existing",
  }

  @track
  _processTagInformation = {
    PromotionsAssociatedWithElectronicInvoice: {
      Code: "",
      Name: "",
    },
    AddOnsAssociatedWithDirectDebit: {
      Code: "",
      Name: "",
    },
  }

  @track _catalogCode = ""
  @track offerCode = ""
  @track offer = null
  @track availableChildProducts = []
  @track includedChildProducts = []
  @track promotions = []
  @track _selectedProduct
  @track totalPrices = { oneTime: 0, recurring: 0 }
  @track messages = []
  @track _offersInConfigurationTemp
  translatedLabelsObj = {}
  selectedAttribute = []
  digitalCommerceSDK = null
  appliedPromotions = []
  availablePromotions = []
  loading = false
  image

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
  set selectedProduct(val) {
    if (val) {
      this._selectedProduct = Object.assign({}, val)
      this.offerCode = this.selectedProduct.code
      this.selectedAttribute = this.selectedProduct.attribute
    }
  }

  get selectedProduct() {
    return this._selectedProduct
  }

  async connectedCallback() {
    if (this.catalogCode && this.offerCode) {
      this.initializeProcessTagInformation()
      this.initializePromotions()
      this.readjustSelectedProductPrice()
      try {
        this.preGetSdkInstance()
        const sdkInstance = await this.getDigitalCommerceSDK()
        this.handleGetSdkInstanceSuccess(sdkInstance)
      } catch (error) {
        this.handleGetSdkInstanceFailure(error)
      }

      this.getTranslationLabels()
    } else {
      console.log("Error", "Missing offerCode and catalogCode params", "error")
    }
  }

  get isDirectDebitIncluded() {
    if (this.isNewCustomer()) {
      return this.isDirectDebitForNewAccount()
    }
    return this.isUsingExistingBillingAccount()
      ? this.isDirectDebitForExistingAccount()
      : this.isDirectDebitForNewAccount()
  }

  get isElectronicInvoiceIncluded() {
    if (this.isNewCustomer()) {
      return this.isElectronicInvoiceForNewAccount()
    }
    return this.isUsingExistingBillingAccount()
      ? this.isElectronicInvoiceForExistingAccount()
      : this.isElectronicInvoiceForNewAccount()
  }

  get compatibleAvailableAddOns() {
    const offerVariantCode = this.selectedProduct.offerVariantCode
    if (offerVariantCode) {
      return this.availableChildProducts.filter(product => {
        const baseOfferVariants = product.customFields?.ALT_PROD_TXT_BaseOfferVariants__c
        const isCompatibleWithAll = !!!baseOfferVariants;
        return isCompatibleWithAll || baseOfferVariants.split(';').includes(offerVariantCode)
      })
    }
    return this.availableChildProducts
  }

  async getTranslationLabels() {
    const labelsToFetch = [
      "ALT_Label_AvailableAddons",
      "ALT_Label_AvailablePromotions",
    ]
    try {
      this.translatedLabelsObj = await this.fetchTranslatedLabels(
        labelsToFetch,
        this.omniJsonData.LanguageCode
      )
    } catch (error) {
      console.log("Error in getting SDK instance ", error)
    }
  }

  initializeProcessTagInformation() {
    try {
      const processTagInformation = this.omniGetMergeField(
        this._CONSTANTS.mergeFields.processTagInformation
      )
      if (processTagInformation) {
        this._processTagInformation = JSON.parse(processTagInformation)
      }
    } catch (error) {
      console.log("error parsing process tag information")
    }
  }

  registerForEvents() {
    this.saveAddonsEventHandler = {
      result: this.saveAddons.bind(this),
    }
    this.configureAddonsEventHandler = {
      result: this.configureAddons.bind(this),
    }
    this.addToCartEventHandler = {
      result: this.addToCart.bind(this),
    }

    this.digitalCommerceSDK.register(
      this._CONSTANTS.events.saveChildOffers,
      this.saveAddonsEventHandler
    )
    this.digitalCommerceSDK.register(
      this._CONSTANTS.events.configureChildOffers,
      this.configureAddonsEventHandler
    )
    this.digitalCommerceSDK.register(
      this._CONSTANTS.events.addToCart,
      this.addToCartEventHandler
    )
  }

  preGetSdkInstance() {
    this.loading = true
  }

  initializePromotions() {
    if (this.selectedProduct.promotions) {
      this.appliedPromotions = []
      this.availablePromotions = []

      this.promotions = this.selectedProduct.promotions

      this.promotions.forEach((promotion) => {
        if (this.shouldPromotionBeApplied(promotion)) {
          this.appliedPromotions.push(promotion)
        } else {
          this.availablePromotions.push(promotion)
        }
      })
    }
  }

  shouldPromotionBeApplied(promotion) {
    const isAutoApplied =
      promotion?.autoAppliedMoment === "At Offer Browse" ||
      promotion?.autoAppliedMoment === "At Order Submit"

    if (this.isElectronicInvoicePromotion(promotion)) {
      return this.isElectronicInvoiceIncluded && isAutoApplied
    }
    return isAutoApplied
  }

  isElectronicInvoicePromotion(promotion) {
    return (
      promotion &&
      this._processTagInformation.PromotionsAssociatedWithElectronicInvoice
        ?.Code &&
      promotion.code ===
      this._processTagInformation.PromotionsAssociatedWithElectronicInvoice
        ?.Code
    )
  }

  handleGetSdkInstanceFailure(error) {
    this.digitalCommerceSDK = null
    this.loading = false
    console.error("Error in getting SDK instance ", error)
  }

  async handleGetSdkInstanceSuccess(sdkInstance) {
    this.loading = false

    this.digitalCommerceSDK = sdkInstance

    this.digitalCommerceSDK.cartContextKey = null //TODO: Remove this part when handling multiple cart item is implemented

    this.registerForEvents()

    const savedState = this.getState()

    if (savedState) {
      this.initializeComponentFromASavedState(savedState)
    } else {
      await this.initializeComponentWithANewState()
    }

    this.manageDirectDebitAddOn()
  }

  async initializeComponentWithANewState() {
    this.digitalCommerceSDK.offersInConfiguration = []
    await this.getOffer()
  }

  initializeComponentFromASavedState(savedState) {
    this.offer = savedState.offer

    this.digitalCommerceSDK.offersInConfiguration =
      savedState.offersInConfiguration

    this.arrangeChildProducts()

    this.calculateTotalPrices()
  }

  async getOffer() {
    const input = this.getOfferGetInput()

    try {
      this.getOfferPreSDKCalls()
      const offerResponse = await this.digitalCommerceSDK.getOffer(input)
      await this.getOfferHandleSuccess(offerResponse)
    } catch (error) {
      this.getOfferHandleFailure(error)
    }
  }

  getOfferPreSDKCalls() {
    this.loading = true
  }

  getOfferGetInput() {
    /*let _input = {
      "catalogCode": this.catalogCode,
      "offerCode": this.offerCode,
      "customFields": ["ALT_PROD_SEL_ProcessTags__c", "ALT_PROD_TXT_BaseOfferVariants__c"]
    }
    let input = this.digitalCommerceSDK.createGetOfferInput(_input);
    return input;*/
    return Object.assign(this.digitalCommerceSDK.createGetOfferInput(), {
      catalogCode: this.catalogCode,
      offerCode: this.offerCode,
      customFields: ["ALT_PROD_SEL_ProcessTags__c", "ALT_PROD_TXT_BaseOfferVariants__c"],
    })
  }

  getOfferHandleFailure(error) {
    this.loading = false
    console.log("Error", "Fail to load Offer =>" + error)
  }

  async getOfferHandleSuccess(offerResponse) {
    this.loading = false
    this.getOfferProcessResponse(offerResponse)
    await this.configureAttributes()
  }

  getOfferProcessResponse(offerResponse) {
    this.offer = Object.assign({}, offerResponse)
    if (this.offer && this.offer.childProducts) {
      this.arrangeChildProducts()
      this.calculateTotalPrices()
    }
  }

  async configureAttributes() {
    const detail = {
      field: "AttributeCategory",
      value: this.initializeAttributeValues(),
    }
    await this.configureOffer(detail)
    this.image = this.offer.attachments[0]
  }

  initializeAttributeValues() {
    let values = []
    for (let attribute of this.selectedAttribute) {
      values.push({
        code: attribute.code,
        userValue: attribute.runtimeValue || attribute.value,
      })
    }
    return values
  }

  async configureOffer(configureOfferObject) {
    const input = this.configureOfferGetInput(configureOfferObject)
    const updatedInput = await this.configureOfferPreHook(input)
    this.configureOfferPreSDKCalls()
    await this.configureOfferSDKCall(updatedInput)
  }

  getAttributesOfAChildProductInConfiguration(childProductCode) {
    const childProduct = this.getChildProductInConfiguration(childProductCode)
    if (!childProduct) {
      return []
    }
    const allAttributes = []

    const { AttributeCategory } = childProduct || {}
    const categories = AttributeCategory?.records || []
    categories.forEach((category) => {
      const { productAttributes } = category || {}
      if (productAttributes?.records) {
        allAttributes.push(...productAttributes?.records)
      }
    })
    return allAttributes
  }
  getChildProductInConfiguration(childProductCode) {
    const offerInConfiguration = this.getOfferInConfiguration()
    if (!childProductCode || !offerInConfiguration) {
      return null
    }
    const { offerDetails } = offerInConfiguration?.result || {}
    const childProducts = offerDetails?.offer?.childProducts || []
    return childProducts.find(
      (product) => product.ProductCode === childProductCode
    )
  }
  getOfferInConfiguration() {
    const offerIndex = this.digitalCommerceSDK.findSelectedOfferIndex(
      this.offerCode
    )
    return offerIndex >= 0
      ? this.digitalCommerceSDK.offersInConfiguration[offerIndex]
      : null
  }
  configureOfferGetInput(configureOfferObject) {
    let currentOffer = this.offer
    let input = Object.assign(
      this.digitalCommerceSDK.createValidateOfferInput(),
      {
        actionObj: this.offer.addtocart,
        offerCode: currentOffer.offerCode,
        catalogCode: this.catalogCode,
        offerConfiguration: configureOfferObject,
        customFields: ["ALT_PROD_SEL_ProcessTags__c", "ALT_PROD_TXT_BaseOfferVariants__c"],
      }
    )
    if (this.context) {
      input.context = this.context
    }
    return input
  }

  configureOfferPreHook(input) {
    return Promise.resolve(input)
  }

  configureOfferPreSDKCalls() {
    this.loading = true
  }

  async configureOfferSDKCall(input) {
    try {
      const response = await this.digitalCommerceSDK.validateOffer(input)
      this.configureOfferProcessResponse(response)
      this.configureOfferPostHook(response)
    } catch (error) {
      this.configureOfferHandleFailure(error)
    }
  }

  configureOfferProcessResponse(response) {
    this.offer = null
    this.selectedOffer = Object.assign({}, response)
    let messages =
      this.digitalCommerceSDK.offersInConfiguration[0].result.messages
    console.log(messages)
    this.messages = messages ? messages : []
    console.log("Success", "Offers updated successfully")
    this.offer = this.selectedOffer
    this.arrangeChildProducts()
    this.calculateTotalPrices()
    this.loading = false
  }

  configureOfferHandleFailure(error) {
    const currentOffer = this.offer
    let errorMessage =
      error.messages && error.messages[0]
        ? error.messages[0]
        : "Failed to update Offer"
    console.log("Error", errorMessage)
    let originalCopy
    if (error.offerBundle) {
      originalCopy = error.offerBundle
    } else {
      originalCopy = this.digitalCommerceSDK.getSelectedOffer(
        currentOffer.offerCode,
        true
      )
    }
    this.selectedOffer = Object.assign({}, originalCopy)
    this.offer = null
    setTimeout(() => {
      this.loading = false
      this.offer = this.selectedOffer
    })
  }

  configureOfferPostHook(response) { }

  manageDirectDebitAddOn() {
    const directDebitAddOn = this.offer?.childProducts?.find((childProduct) =>
      this.isDirectDebitAddOn(childProduct)
    )
    if (directDebitAddOn) {
      const desiredQuantity = this.isDirectDebitIncluded ? 1 : 0
      if (directDebitAddOn.quantity !== desiredQuantity) {
        directDebitAddOn.quantity = desiredQuantity
        this.saveAddons(directDebitAddOn)
      }
    }
  }

  isDirectDebitAddOn(childProduct) {
    return (
      childProduct &&
      this._processTagInformation.AddOnsAssociatedWithDirectDebit?.Code &&
      childProduct.offerCode ===
      this._processTagInformation.AddOnsAssociatedWithDirectDebit?.Code
    )
  }

  async saveAddons(childProduct) {
    if (this.loading) {
      return
    }
    let input = this.saveAddonsGetInput(childProduct)
    const updatedInput = await this.saveAddonsPreHook(input)
    this.saveAddonsPreSDKCalls()
    this.saveAddonsSDKCall(updatedInput)
  }

  saveAddonsGetInput(childProduct) {
    return Object.assign(this.digitalCommerceSDK.createValidateOfferInput(), {
      offerConfiguration: childProduct.updatedSelection
        ? childProduct.updatedSelection
        : childProduct,
      offerCode: this.offerCode,
      catalogCode: this.catalogCode,
      customFields: ["ALT_PROD_SEL_ProcessTags__c", "ALT_PROD_TXT_BaseOfferVariants__c"],
    })
  }

  saveAddonsPreHook(input) {
    this.loading = true
    return Promise.resolve(input)
  }

  saveAddonsPreSDKCalls() { }

  saveAddonsSDKCall(input) {
    // Invoke confugure offer API via method validateOffer()
    this.digitalCommerceSDK
      .validateOffer(input)
      .then((response) => {
        this.saveAddonsProcessResponse(response)
        this.saveAddonsPostHook(response)
        let messages =
          this.digitalCommerceSDK.offersInConfiguration[0].result.messages
        this.messages = messages ? messages : []
      })
      .catch((error) => {
        this.saveAddonsHandleFailure(error)
      })
  }

  saveAddonsProcessResponse(response) {
    console.log("Success", "child products updated successfully", response)
    this.offer = null
    this.selectedOffer = Object.assign({}, response)
    let messages =
      this.digitalCommerceSDK.offersInConfiguration[0].result.messages
    console.log(messages)
    this.messages = messages ? messages : []
    setTimeout(() => {
      this.offer = this.selectedOffer
      this.arrangeChildProducts()
      this.calculateTotalPrices()
      this.loading = false
    })
  }

  saveAddonsPostHook(response) { }

  saveAddonsHandleFailure(error) {
    let errorMessage =
      error.messages && error.messages[0]
        ? error.messages[0]
        : this.translatedLabelsObj.DCChildProductFailure
    this.showToast("Error", errorMessage, "error", this)
    setTimeout(() => {
      let data
      if (error.offerBundle) {
        data = error.offerBundle
      } else {
        data = this.digitalCommerceSDK.getSelectedOffer(this.offerCode, true)
      }
      this.initUpdateOffer(
        {
          offer: JSON.parse(JSON.stringify(data)),
          paymentType: this.paymentType,
          catalogCode: this.catalogCode,
        },
        this.planGroupIndex
      )
    }, 350)
  }

  configureAddons(details) {
    this.updateChildProductAttributesWithUserValues({
      offerCode: details.offerCode,
      values: [
        {
          code: details.attributeCode,
          userValue: details.selectedValue,
        },
      ],
    })
    //This call to the sdk 'validate offer' with dummy data will ensure that the sdk will validate the offer and make the http call to propagate the changes we made earlier to the attributes.
    //Why not let the sdk make the changes we did? it's because the sdk doesn't have a filter on the child product when it comes to changing an attribute.
    //For example if we want to change data attribute of a child product, the sdk unfortunately will go throught all child product and set uservalues to the chosen option for the attribute.
    //What we achieved with this, is customizing the logic of attribute change by doing it before the call and calling sdk with dummy data so that the sdk doesn't attempt to change anything else than making the http calls.
    //To understand more check the digitalcommerce.sdk.ts file , validateOffer method L740 (around) focus on Offer.updateOffer call. You will find the logic that we tried to override implicitly in Offer.ts file search for 'ChildAttributeCategory'
    const detail = {
      field: "ChildAttributeCategory",
      value: [], // "dummyCodeToFakeTheSDKCall"
    }
    this.configureOffer(detail)
    this.image = this.offer.attachments[0]
  }

  updateChildProductAttributesWithUserValues(configureOfferObject) {
    if (configureOfferObject && configureOfferObject.values?.length > 0) {
      const attributes = this.getAttributesOfAChildProductInConfiguration(
        configureOfferObject.offerCode
      )
      if (attributes?.length > 0) {
        const attributeMap = new Map(
          attributes.map((attribute) => [attribute.code, attribute])
        )

        configureOfferObject.values.forEach((value) => {
          const attribute = attributeMap.get(value.code)
          if (attribute) {
            attribute.userValues = value.userValue
          }
        })
      }
    }
  }

  async addToCart() {
    const input = this.addToCartGetInput()
    const updatedInput = await this.addToCartPreHook(input)
    this.addToCartPreSDKCalls()
    this.addToCartSDKCall(updatedInput)
  }

  addToCartGetInput() {
    let selectedOffer = this.digitalCommerceSDK.getSelectedOffer(
      this.offer.offerCode
    ).result
    let input = Object.assign(this.digitalCommerceSDK.createAddToCartInput(), {
      catalogCode: this.catalogCode,
      offerConfiguration: selectedOffer,
      basketAction: "AddAfterConfig",
      cartContextKey: null,
    })
    return input
  }

  async addPromotions() {
    const input = this.addPromotionsToCartGetInput()
    const updatedInput = await this.addToCartPreHook(input)
    this.addToCartPreSDKCalls()
    this.addPromotionsToCartSDKCall(updatedInput)
  }

  addPromotionsToCartGetInput() {
    let input = Object.assign(this.digitalCommerceSDK.createAddToCartInput(), {
      catalogCode: this.catalogCode,
      offerCode: this.appliedPromotions
        .filter((promo) => promo.autoAppliedMoment === "At Offer Browse")
        .map((promo) => promo.code),
      basketAction: "AddPromotion",
      cartContextKey: this.digitalCommerceSDK.cartContextKey
        ? this.digitalCommerceSDK.cartContextKey
        : null,
    })
    return input
  }

  addToCartPreHook(input) {
    return Promise.resolve(input)
  }

  addToCartPreSDKCalls() {
    this.loading = true
  }

  addToCartSDKCall(input) {
    this.cacheOffersInConfiguration()
    this.digitalCommerceSDK
      .addToCart(input)
      .then((cartResponse) => {
        this.addToCartProcessResponse(cartResponse)
        this.addToCartPostHook(cartResponse)
      })
      .catch((error) => {
        this.addToCartHandleFailure(error)
      })
  }

  cacheOffersInConfiguration() {
    this._offersInConfigurationTemp = [
      ...this.digitalCommerceSDK.offersInConfiguration,
    ] //We cache "offers in configuration" in a variable  _offersInConfigurationTemp, because after the call 'add to cart' it gets empties ==> It is used for saving the state
  }

  addPromotionsToCartSDKCall(input) {
    this.digitalCommerceSDK
      .addToCart(input)
      .then((cartResponse) => {
        this.addPromotionsToCartProcessResponse(cartResponse)
        this.addToCartPostHook(cartResponse)
      })
      .catch((error) => {
        this.addToCartHandleFailure(error)
      })
  }

  addToCartProcessResponse(cartResponse) {
    if (cartResponse && cartResponse.cartContextKey) {
      console.log("addtocart response", this.digitalCommerceSDK.cartResponse)
      this.addPromotions()
    }
  }

  addPromotionsToCartProcessResponse(cartResponse) {
    if (cartResponse && cartResponse.cartContextKey) {
      console.log("addtocart response", this.digitalCommerceSDK.cartResponse)
      this.omniApplyCallResp(
        { basket: this.digitalCommerceSDK.cartResponse },
        true
      )
      this.advanceOSNextStep() // auto-advance to the omniscript shopping cart step
    }
    this.loading = false
  }

  addToCartHandleFailure(error) {
    let errorMessage =
      error.messages && error.messages[0]
        ? error.messages[0]
        : "Failed to update cart"
    if (
      !error.messages &&
      (error.errorCode === 422 || error.errorCode === "422") &&
      error.error
    ) {
      errorMessage = error.error
    }
    this.showToast("Error", errorMessage, "error", this)
    this.loading = false
  }

  addToCartPostHook(response) { }

  arrangeChildProducts() {
    this.availableChildProducts = this.offer?.childProducts?.filter(
      (product) => product.quantity === 0
    )
    this.includedChildProducts = this.offer?.childProducts?.filter(
      (product) => product.quantity > 0
    )
  }

  calculateTotalPrices() {
    let total = this.offer.priceInfo.recurringChargeInfo.recurringTotal
    let onetimeTotal = this.offer.priceInfo.oneTimeChargeInfo.onetimeTotal | 0
    for (let index = 0; index < this.appliedPromotions.length; index++) {
      if (
        this.appliedPromotions[index].autoAppliedMoment === "At Offer Browse"
      ) {
        total += parseFloat(this.appliedPromotions[index].chargeAmount)
      }
    }
    this.totalPrices = { oneTime: onetimeTotal, recurring: total }
  }

  readjustSelectedProductPrice() {
    let adjustedSelectedPrice = parseFloat(this.selectedProduct.initialAmount)
    this.appliedPromotions
      ?.filter((promotion) => promotion.autoAppliedMoment === "At Offer Browse")
      ?.forEach((promotion) => {
        adjustedSelectedPrice += parseFloat(promotion.chargeAmount)
      })
    this._selectedProduct.price = adjustedSelectedPrice
  }

  isUsingExistingBillingAccount() {
    return (
      this.omniGetMergeField(this._CONSTANTS.mergeFields.existingOrNewBA)
        ?.toLowerCase()
        ?.includes(this._CONSTANTS.existing) && this.selectedBillingAccount()
    )
  }

  selectedBillingAccount() {
    return this.omniGetMergeField(
      this._CONSTANTS.mergeFields.selectedBillingAcocunt
    )
  }

  isNewCustomer() {
    return this.omniGetMergeField(this._CONSTANTS.mergeFields.isNewCustomer)
  }

  isDirectDebitForNewAccount() {
    return (
      this.omniGetMergeField(this._CONSTANTS.mergeFields.paymentMethod) ===
      this._CONSTANTS.directDebitPaymentMethod
    )
  }

  isDirectDebitForExistingAccount() {
    return this.selectedBillingAccount()
      ? JSON.parse(this.selectedBillingAccount()).PaymentMethod !==
      this._CONSTANTS.atmPaymentMethod
      : false
  }

  isElectronicInvoiceForNewAccount() {
    return (
      this.omniGetMergeField(this._CONSTANTS.mergeFields.deliveryMethod) !==
      this._CONSTANTS.paperBillingDeliveryMethod
    )
  }

  isElectronicInvoiceForExistingAccount() {
    return this.selectedBillingAccount()
      ? JSON.parse(this.selectedBillingAccount()).DeliveryMethod ===
      this._CONSTANTS.electronicInvoiceDeliveryMethod
      : false
  }

  render() {
    return componentTemplate
  }

  getState() {
    const key = this._CONSTANTS.key
    return this.omniGetSaveState(key)
  }

  unregisterForEvents() {
    if (this.digitalCommerceSDK) {
      this.digitalCommerceSDK.unregister(
        this._CONSTANTS.events.saveChildOffers,
        this.saveAddonsEventHandler
      )
      this.digitalCommerceSDK.unregister(
        this._CONSTANTS.events.configureChildOffers,
        this.configureAddonsEventHandler
      )
      this.digitalCommerceSDK.unregister(
        this._CONSTANTS.events.addToCart,
        this.addToCartEventHandler
      )
    }
  }

  saveState() {
    const key = this._CONSTANTS.key
    const usePubSub = true
    this.omniSaveState(
      {
        offer: this.offer,
        offersInConfiguration: this._offersInConfigurationTemp,
      },
      key,
      usePubSub
    )
  }

  disconnectedCallback() {
    this.saveState()
    this.unregisterForEvents()
  }
}