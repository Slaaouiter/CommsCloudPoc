@isTest
private class VNOS_DOMAIN_Promotion_Test {
  @isTest
  static void constructorCanCreateAPromotionFromAMap() {
    //Given
    Map<String, Object> recordTypeNode = new Map<String, Object>();
    recordTypeNode.put('DeveloperName', 'Promotion');

    Map<String, Object> productNode = new Map<String, Object>();
    productNode.put(VNOS_DOMAIN_Product.CONST_NAME, 'UZO Móvel');
    productNode.put(VNOS_DOMAIN_Product.CONST_CODE, 'VNOS_OFFERING_UZO_MOBILE');

    Map<String, Object> productsNode = new Map<String, Object>();
    productsNode.put('UZO Móvel', productNode);

    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(VNOS_DOMAIN_Promotion.CONST_CHARGE_AMOUNT, -3.5);
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_PRODUCT,
      productsNode.values()
    );

    //When
    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion(promotionNode);

    //Then
    System.assert(promotion != null, 'promotion should not be null');
    System.assert(
      promotion.recordType != null,
      'recordType should not be null'
    );
    System.assert(promotion.products != null, 'products should not be null');
    System.assert(promotion.price != null, 'price should not be null');
  }

  @isTest
  static void name() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(VNOS_DOMAIN_Promotion.CONST_NAME, 'ElectronicInvoice');

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String name = promotion.name();

    //Then
    System.assert(
      'ElectronicInvoice'.equals(name),
      'name should be equal to ElectronicInvoice'
    );
  }

  @isTest
  static void code() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VLOCITY_CMT_CODE_C,
      'ElectronicInvoice'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String code = promotion.code();

    //Then
    System.assert(
      'ElectronicInvoice'.equals(code),
      'code should be equal to ElectronicInvoice'
    );
  }

  @isTest
  static void description() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VLOCITY_CMT_DESCRIPTION_C,
      'This is a description'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String description = promotion.description();

    //Then
    System.assert(
      'This is a description'.equals(description),
      'description should be equal to This is a description'
    );
  }

  @isTest
  static void autoAppliedMoment() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      'At Browse Offer'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String autoAppliedMoment = promotion.autoAppliedMoment();

    //Then
    System.assert(
      'At Browse Offer'.equals(autoAppliedMoment),
      'auto apply moment should be equal to At Browse Offer'
    );
  }

  @isTest
  static void isLoyalty() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_FLG_IS_LOYALTY_C,
      true
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isLoyalty = promotion.isLoyalty();

    //Then
    System.assert(isLoyalty, 'isLoyalty should be true');
  }

  @isTest
  static void isLoyaltyReturnsFalseIfAnExceptionOccurs() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_FLG_IS_LOYALTY_C,
      null
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isLoyalty = promotion.isLoyalty();

    //Then
    System.assert(!isLoyalty, 'isLoyalty should be false');
  }

  @isTest
  static void processTags() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_PROCESS_TAGS_C,
      VNOS_DOMAIN_Promotion.CONST_LOYALTY_DEPENDENT
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String processTags = promotion.processTags();

    //Then
    System.assert(
      processTags.equals(VNOS_DOMAIN_Promotion.CONST_LOYALTY_DEPENDENT),
      'processTags should be Loyalty dependent'
    );
  }

  @isTest
  static void baseOfferVariants() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C,
      '1GB_500MB'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String baseOfferVariants = promotion.baseOfferVariants();

    //Then
    System.assert(
      '1GB_500MB'.equals(baseOfferVariants),
      'baseOfferVariants should be 1GB_500MB and not' + baseOfferVariants
    );
  }
  @isTest
  static void applicableToOfferVariantReturnsTrueIfApplicable() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C,
      '1GB_500MB;2GB_500MB'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isApplicableToOfferVariant = promotion.applicableToOfferVariant(
      '1GB_500MB'
    );

    //Then
    System.assert(isApplicableToOfferVariant, 'result should be true');
  }
  @isTest
  static void applicableToOfferVariantReturnsFalseIfNotApplicable() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXT_BASE_OFFER_VARIANTS_C,
      '1GB_500MB;2GB_500MB'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isApplicableToOfferVariant = promotion.applicableToOfferVariant(
      '3GB_500MB'
    );

    //Then
    System.assert(!isApplicableToOfferVariant, 'result should be false');
  }
  @isTest
  static void isLoyaltyExcludedReturnsTrueIfProcessTagContainLoyaltyExcluded() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_PROCESS_TAGS_C,
      'LoyaltyDependent;LoyaltyExcluded'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isLoyaltyExcluded = promotion.isLoyaltyExcluded();

    //Then
    System.assert(isLoyaltyExcluded, 'isLoyaltyExcluded should be true');
  }
  @isTest
  static void isLoyaltyExcludedReturnsFalseIfAnExceptionOccurs() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_PROCESS_TAGS_C,
      null
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isLoyaltyExcluded = promotion.isLoyaltyExcluded();

    //Then
    System.assert(!isLoyaltyExcluded, 'isLoyaltyExcluded should be false');
  }

  @isTest
  static void isLoyaltyDependentReturnsTrueIfProcessTagContainLoyaltyDependent() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_PROCESS_TAGS_C,
      'LoyaltyDependent;promoOnly'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isLoyaltyDependent = promotion.isLoyaltyDependent();

    //Then
    System.assert(isLoyaltyDependent, 'isLoyaltyDependent should be true');
  }

  @isTest
  static void isLoyaltyDependentReturnsFalseIfAnExceptionOccurs() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_PROCESS_TAGS_C,
      null
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isLoyaltyDependent = promotion.isLoyaltyDependent();

    //Then
    System.assert(!isLoyaltyDependent, 'isLoyaltyDependent should be false');
  }

  @isTest
  static void browseHighlightingPosition() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Center'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String browseHighlightingPosition = promotion.browseHighlightingPosition();

    //Then
    System.assert(
      'Center'.equals(browseHighlightingPosition),
      'position should be equal to Center'
    );
  }

  @isTest
  static void isAutoAppliedReturnsTrueIfAutoAppliedMomentIsNotBlank() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      'At Offer Browse'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isAutoApplied = promotion.isAutoApplied();

    //Then
    System.assert(isAutoApplied, 'isAutoApplied should be true');
  }

  @isTest
  static void isAutoAppliedReturnsFalseIfAutoAppliedMomentIsBlank() {
    //Given
    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = new Map<String, Object>();

    //When
    Boolean isAutoApplied = promotion.isAutoApplied();

    //Then
    System.assert(!isAutoApplied, 'isAutoApplied should be false');
  }

  @isTest
  static void isAutoAppliedAtOfferBrowseReturnTrueIfAutoAppliedMomentIsOfferBrowse() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isAutoAppliedAtOfferBrowse = promotion.isAutoAppliedAtOfferBrowse();

    //Then
    System.assert(
      isAutoAppliedAtOfferBrowse,
      'isAutoAppliedAtOfferBrowse should be true'
    );
  }

  @isTest
  static void isAutoAppliedAtOfferBrowseReturnFalseIfAutoAppliedMomentIsNotOfferBrowse() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      'At Submit Offer'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    Boolean isAutoAppliedAtOfferBrowse = promotion.isAutoAppliedAtOfferBrowse();

    //Then
    System.assert(
      !isAutoAppliedAtOfferBrowse,
      'isAutoAppliedAtOfferBrowse should be false'
    );
  }

  @isTest
  static void price() {
    //Given
    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();
    price.chargeAmount('1.5');

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();

    //When
    promotion.price(price);

    //Then
    System.assert(promotion.price != null, 'price is not null');
    System.assert(
      '1.5'
        .equals(
          String.valueOf(
            promotion.node.get(VNOS_DOMAIN_Promotion.CONST_CHARGE_AMOUNT)
          )
        ),
      'charge amount was not set on the promotion'
    );
  }

  @isTest
  static void publicLongDesc() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXT_PUBLIC_LONG_DESC_C,
      'Oferta 1ª mensalidade'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String publicLongDesc = promotion.publicLongDesc();

    //Then
    System.assert(
      'Oferta 1ª mensalidade'.equals(publicLongDesc),
      'publicLongDesc should be equal to Oferta 1ª mensalidade'
    );
  }

  @isTest
  static void publicShortDesc() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_TXTL_PUBLIC_SHORT_DESC_C,
      'Campanha Verão'
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.node = promotionNode;

    //When
    String publicShortDesc = promotion.publicShortDesc();

    //Then
    System.assert(
      'Campanha Verão'.equals(publicShortDesc),
      'publicShortDesc should be equal to Campanha Verão'
    );
  }

  @isTest
  static void applyVAT() {
    //Given
    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();
    price.amount('1.2195');

    VNOS_DOMAIN_Prices prices = new VNOS_DOMAIN_Prices();
    prices.elements.add(price);

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();
    product.prices = prices;

    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();
    products.elements.add(product);

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.products = products;

    //When
    promotion.applyVAT();

    //Then
    System.assert(
      '1.50'.equals(product.prices.getPrice().amount()),
      product.prices.getPrice().amount() + ' should be 1.5'
    );
  }

  @isTest
  static void addToMapCreatesANewEntryIfTheMapDoesNotHaveTheProductCode() {
    //Given
    Map<String, String> productCodeToContextProductCode = new Map<String, String>();
    productCodeToContextProductCode.put('UZO_MOBILE', 'UZO_MOBILE');

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();
    price.chargeAmount('1.5');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();
    product.node.put(VNOS_DOMAIN_Product.CONST_CODE, 'UZO_MOBILE');

    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();
    products.elements.add(product);

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.price = price;
    promotion.products = products;

    Map<String, VNOS_DOMAIN_Promotions> productCodeToPromotions = new Map<String, VNOS_DOMAIN_Promotions>();

    //When
    promotion.addToMap(
      productCodeToPromotions,
      productCodeToContextProductCode
    );

    //Then
    System.assert(
      productCodeToPromotions.containsKey(product.code()),
      'should contain an entry with the product code'
    );
  }

  @isTest
  static void addToMapAddsToAnEntryIfTheMapHaveTheProductCode() {
    //Given
    Map<String, String> productCodeToContextProductCode = new Map<String, String>();
    productCodeToContextProductCode.put('UZO_MOBILE', 'UZO_MOBILE');

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();
    price.chargeAmount('1.5');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();
    product.node.put(VNOS_DOMAIN_Product.CONST_CODE, 'UZO_MOBILE');

    VNOS_DOMAIN_Products products = new VNOS_DOMAIN_Products();
    products.elements.add(product);

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.price = price;
    promotion.products = products;

    Map<String, VNOS_DOMAIN_Promotions> productCodeToPromotions = new Map<String, VNOS_DOMAIN_Promotions>();
    VNOS_DOMAIN_Promotions alreadyAddedPromotions = new VNOS_DOMAIN_Promotions();
    alreadyAddedPromotions.elements.add(new VNOS_DOMAIN_Promotion());

    productCodeToPromotions.put('UZO_MOBILE', alreadyAddedPromotions);

    //When
    promotion.addToMap(
      productCodeToPromotions,
      productCodeToContextProductCode
    );

    //Then
    System.assert(
      productCodeToPromotions.containsKey(product.code()),
      'should contain an entry with the product code'
    );
    System.assert(
      productCodeToPromotions.get('UZO_MOBILE').elements.size() == 2,
      'should contain 2 elements'
    );
  }

  @isTest
  static void duplicate() {
    //Given
    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(VNOS_DOMAIN_Promotion.CONST_NAME, 'Electronic Invoice');

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion(promotionNode);

    //When
    VNOS_DOMAIN_Promotion duplicate = promotion.duplicate();

    //Then
    System.assert(duplicate != null, 'duplicate should not be null');
    System.assert(
      'Electronic Invoice'.equals(duplicate.name()),
      'name was not duplicated'
    );
  }
  @isTest
  static void toResponse() {
    //Given
    Map<String, Object> priceNode = new Map<String, Object>();
    priceNode.put(VNOS_DOMAIN_Price.CONST_CHARGE_AMOUNT, '13.00');
    priceNode.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_RECURRING
    );

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(priceNode);

    Map<String, Object> promotionNode = new Map<String, Object>();
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_NAME,
      'Desconto por Factura Electrónica'
    );
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VLOCITY_CMT_CODE_C,
      'VNOS_DISC_PROMO_ON_ELECTRONIC_INVOICE'
    );
    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VLOCITY_CMT_DESCRIPTION_C,
      'Desconto por Factura Electrónica'
    );

    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_BROWSE_HIGHLIGHTING_C,
      'Center'
    );

    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      'At Browse Offer'
    );

    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_FLG_IS_LOYALTY_C,
      true
    );

    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_FLG_KEEP_TARIFF_C,
      true
    );

    promotionNode.put(VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_ID_C, '');

    promotionNode.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_PROCESS_TAGS_C,
      VNOS_DOMAIN_Promotion.CONST_LOYALTY_DEPENDENT
    );

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion(promotionNode);
    promotion.price = price;

    //When
    Map<String, Object> response = promotion.toResponse();

    //Then
    System.assertEquals(
      promotion.name(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_NAME),
      'Name is wrong'
    );
    System.assertEquals(
      promotion.code(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_CODE),
      'Code is wrong'
    );
    System.assertEquals(
      promotion.description(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_DESCRIPTION),
      'Description is wrong'
    );
    System.assertEquals(
      promotion.autoAppliedMoment(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_AUTO_APPLIED_MOMENT),
      'AutoAppliedMoment is wrong'
    );
    System.assertEquals(
      promotion.browseHighlightingPosition(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_POSITION),
      'Position is wrong'
    );
    System.assertEquals(
      promotion.price.isRecurringCharge(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_HAS_RECURRING_CHARGE),
      'isRecurringCharge is wrong'
    );
    System.assertEquals(
      promotion.price.chargeAmount(),
      response.get(VNOS_DOMAIN_Promotion.CONST_CHARGE_AMOUNT),
      'ChargeAmount is wrong'
    );
    System.assertEquals(
      promotion.isLoyalty(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_IS_LOYALTY),
      'isLoyalty is wrong'
    );
    System.assertEquals(
      promotion.isLoyaltyDependent(),
      response.get(VNOS_DOMAIN_Promotion.OUTPUT_IS_LOYALTY_DEPENDENT),
      'isLoyaltyDependent is wrong'
    );
  }
}