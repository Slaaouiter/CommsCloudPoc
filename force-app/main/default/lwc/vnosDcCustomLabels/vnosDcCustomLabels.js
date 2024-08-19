let dcCustomLabels = [
  "Next",
  "CPQAddToCart",
  "OneTime",
  "CPQLoadMore",
  "CPQSubmit",
  "CPQOr",
  "DCNoAddOns",
  "DCMoreAddOns",
  "Remove",
  "DCDueToday",
  "DCQuantity",
  "DCMyBasket",
  "DCDueMonthly",
  "DCSpecialOffer",
  "DCContinueShopping",
  "DCPayment",
  "DCAvailableIn",
  "DCRecurring",
  "DCSubTotal",
  "DCStartingFrom",
  "DCGoBackToShop",
  "DCYourCartIsEmpty",
  "DCMyCart",
  "DCCheckout",
  "DCTermsConditions",
  "DCPersonalInfo",
  "DCNewCustomer",
  "DCExistingCustomer",
  "DCContactInfo",
  "DCFirstName",
  "DCLastName",
  "DCPhone",
  "DCEmailAddress",
  "DCPassword",
  "DCLoginInfo",
  "DCEmail",
  "DCFillRequiredFields",
  "DCInvalidEmail",
  "DCSignUpSuccess",
  "DCReviewOrder",
  "DCContactInformation",
  "DCBillingAddress",
  "DCShippingAddress",
  "DCPaymentFailed",
  "DCSignInSuccess",
  "OrderSubmissionAccepted",
  "DCBillingAndShipping",
  "DCBillingAddress",
  "DCAddress",
  "DCCity",
  "DCState",
  "DCZipCode",
  "DCShippingAddress",
  "DCSameBilling",
  "DCAccUpdateSuccess",
  "DCFillRequiredFields",
  "DCConfirmPassword",
  "DCIncorrectPassword",
  "DCPaymentSuccess",
  "DCRefine",
  "PCToastErrorTitle",
  "PCToastSuccessTitle",
  "DCChildProductFailure",
  "DCAvailablePromotions",
  "DCApplyPromo",
  "DCMyAccount",
  "DCSignOut",
  "DCSignIn",
  "CPQCancel",
  "DCMyAssets",
  "ASSETNoAssets",
  "DCModify",
  "Quantity",
  "CPQPromotions",
  "ALT_Action_AddToCart",
  "ALT_Label_OneTimeCharge",
  "ALT_Label_RecurringCharge",
  "ALT_Label_TotalOffer",
  "ALT_Label_AvailableAddons",
  "ALT_Label_AvailablePromotions",
  "ALT_Label_AppliedPromotions",
  "ALT_Action_Add",
  "ALT_Label_Quantity",
  "ALT_Action_Remove"
];

let labels = {};

export function getLabels(translationSDK, language) {
  return new Promise((resolve, reject) => {
    const fetchTranslationsInput = translationSDK.createFetchTranslationsInput();
    fetchTranslationsInput.textToTranslate = dcCustomLabels;
    fetchTranslationsInput.language = language;
    if (!labels[language]) {
      labels[language] = translationSDK.fetchTranslations(
        fetchTranslationsInput
      );
      resolve(labels[language]);
    } else {
      resolve(labels[language]);
    }
  });
}

export function addCustomLabels(newLabels) {
  dcCustomLabels = [...dcCustomLabels, ...newLabels];
}