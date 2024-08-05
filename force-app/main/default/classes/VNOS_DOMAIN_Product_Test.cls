@isTest
private class VNOS_DOMAIN_Product_Test {
  @isTest
  static void constructorCanCreateAProductFromAMap() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_PRICE_RESULT, new List<Object>());
    productMap.put(
      VNOS_DOMAIN_Product.CONST_ATTRIBUTE_CATEGORY,
      new Map<String, Object>()
    );
    productMap.put(VNOS_DOMAIN_Product.OUTPUT_PROMOTIONS, new List<Object>());

    //When
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //Then
    System.assert(product != null, 'product should not be null');
    System.assert(product.node == productMap, 'node should = productMap');
    System.assert(product.prices != null, 'prices should not be null');
    System.assert(product.attributes != null, 'attributes should not be null');
    System.assert(product.promotions != null, 'promotions should not be null');
  }

  @isTest
  static void code() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_CODE, 'UZO');
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    String code = product.code();

    //Then
    System.assert('UZO'.equals(code), 'code should be uzo');
  }

  @isTest
  static void name() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_NAME, 'Uzo Mobile');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    String name = product.name();

    //Then
    System.assert('Uzo Mobile'.equals(name), 'name should be Uzo Mobile');
  }

  @isTest
  static void nameSetter() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_NAME, 'Uzo Mobile');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    product.name('Meo Mobile');

    //Then
    System.assert(
      'Meo Mobile'.equals(product.name()),
      'name should be Meo Mobile'
    );
  }

  @isTest
  static void publicOfferName() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(
      VNOS_DOMAIN_Product.CONST_PUBLIC_OFFER_NAME,
      'Uzo Mobile offer'
    );

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    String publicOfferName = product.publicOfferName();

    //Then
    System.assert(
      'Uzo Mobile offer'.equals(publicOfferName),
      'public offer name should be Uzo Mobile offer'
    );
  }

  @isTest
  static void publicOfferNameSetter() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(
      VNOS_DOMAIN_Product.CONST_PUBLIC_OFFER_NAME,
      'Uzo Mobile offer'
    );

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    product.publicOfferName('Meo Mobile offer');

    //Then
    System.assert(
      'Meo Mobile offer'.equals(product.publicOfferName()),
      'public offer name should be Meo Mobile offer'
    );
  }

  @isTest
  static void commercialDescription() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(
      VNOS_DOMAIN_Product.CONST_COMMERCIAL_DESCRIPTION,
      'Good Offer'
    );

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    String commercialDescription = product.commercialDescription();

    //Then
    System.assert(
      'Good Offer'.equals(commercialDescription),
      'commercial description  should be Good Offer'
    );
  }

  @isTest
  static void commercialDescriptionSetter() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(
      VNOS_DOMAIN_Product.CONST_COMMERCIAL_DESCRIPTION,
      'Good Offer'
    );

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    product.commercialDescription('Best Offer');

    //Then
    System.assert(
      'Best Offer'.equals(product.commercialDescription()),
      'commercial description  should be Best Offer'
    );
  }

  @isTest
  static void orderOfGroup() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_ORDER_OF_GROUP, '1');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    Integer orderOfGroup = product.orderOfGroup();

    //Then
    System.assert(orderOfGroup == 1, 'order of group should be 1');
  }

  @isTest
  static void orderOfGroupReturns0IfAnExceptionOccurs() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_ORDER_OF_GROUP, 'A112');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    Integer orderOfGroup = product.orderOfGroup();

    //Then
    System.assert(orderOfGroup == 0, 'order of group should be 0');
  }

  @isTest
  static void orderOfGroupSetter() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_ORDER_OF_GROUP, '1');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    product.orderOfGroup(2);

    //Then
    System.assert(product.orderOfGroup() == 2, 'order of group should be 2');
  }

  @isTest
  static void orderInGroupe() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_ORDER_IN_GROUP, '1');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    product.orderInGroupe();

    //Then
    System.assert(product.orderInGroupe() == 1, 'order in group should be 1');
  }

  @isTest
  static void orderInGroupReturns0IfAnExceptionOccurs() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_ORDER_IN_GROUP, 'A112');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    Integer orderInGroupe = product.orderInGroupe();

    //Then
    System.assert(orderInGroupe == 0, 'order in group should be 0');
  }

  @isTest
  static void orderInGroupSetter() {
    //Given
    Map<String, Object> productMap = new Map<String, Object>();
    productMap.put(VNOS_DOMAIN_Product.CONST_ORDER_IN_GROUP, '1');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product(productMap);

    //When
    product.orderInGroupe(2);

    //Then
    System.assert(product.orderInGroupe() == 2, 'order in group should be 2');
  }

  @isTest
  static void promotionsSetter() {
    //Given
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();
    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();

    //When
    product.promotions(promotions);

    //Then
    System.assert(
      product.promotions == promotions,
      'promotions should be equals'
    );
  }
  @isTest
  static void updateDataAccordingToAttributePricingMatrixRow() {
    //Given
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();
    VNOS_DOMAIN_AttributePricingMatrixRow row = new VNOS_DOMAIN_AttributePricingMatrixRow();
    row.itemName = 'Uzo 1GB';
    row.pitchOrder = '1-2';
    row.publicOfferName = 'Uzo Official 1GB';
    row.commercialDescription = 'Description';

    //When
    product.updateFromMatrixRow(row);

    //Then
    System.assert(
      product.name().equals(row.itemName),
      product.name() + ' should be ' + row.itemName
    );
    System.assert(
      product.orderOfGroup() == 1,
      product.orderOfGroup() + ' should be 1'
    );
    System.assert(
      product.orderInGroupe() == 2,
      product.orderOfGroup() + ' should be 2'
    );
    System.assert(
      product.publicOfferName().equals(row.publicOfferName),
      product.publicOfferName() + ' should be ' + row.publicOfferName
    );
    System.assert(
      product.commercialDescription().equals(row.commercialDescription),
      product.commercialDescription() +
        ' should be ' +
        row.commercialDescription
    );
    //Missing Assertion on prices and attributes
  }

  @isTest
  static void autoApplyPromotionsAtBrowseOffer() {
    //Given
    VNOS_DOMAIN_Price electronicInvoicePrice = new VNOS_DOMAIN_Price();
    electronicInvoicePrice.chargeAmount('-1.5');

    VNOS_DOMAIN_Promotion electronicInvoice = new VNOS_DOMAIN_Promotion();
    electronicInvoice.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );
    electronicInvoice.price = electronicInvoicePrice;

    VNOS_DOMAIN_Price oneMonthFreePrice = new VNOS_DOMAIN_Price();
    oneMonthFreePrice.chargeAmount('-3');

    VNOS_DOMAIN_Promotion oneMonthFree = new VNOS_DOMAIN_Promotion();
    oneMonthFree.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      'At Order Submit'
    );
    oneMonthFree.price = oneMonthFreePrice;

    VNOS_DOMAIN_Price fidelizationPrice = new VNOS_DOMAIN_Price();
    fidelizationPrice.chargeAmount('-1');

    VNOS_DOMAIN_Promotion fidelization = new VNOS_DOMAIN_Promotion();
    fidelization.node.put(
      VNOS_DOMAIN_Promotion.CONST_VNOS_PROM_SEL_AUTO_APPLY_MOMENT_C,
      VNOS_DOMAIN_Promotion.CONST_AT_OFFER_BROWSE
    );
    fidelization.price = fidelizationPrice;

    VNOS_DOMAIN_Price productPrice = new VNOS_DOMAIN_Price();
    productPrice.amount('10');

    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();
    product.prices.elements.add(productPrice);
    VNOS_DOMAIN_Promotions promotions = new VNOS_DOMAIN_Promotions();
    promotions.elements = new List<VNOS_DOMAIN_Promotion>{
      electronicInvoice,
      oneMonthFree,
      fidelization
    };

    product.promotions(promotions);

    //When
    product.autoApplyPromotionsAtBrowseOffer();

    //Then
    System.assert(
      product.prices.getPrice().amount().equals('7.5'),
      'new amount should be equal 7.5 not ' + product.prices.getPrice().amount()
    );
  }

  @isTest
  static void applyVAT() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_ONE_TIME
    );
    node.put(VNOS_DOMAIN_Price.CONST_AMOUNT, 1.2195);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    VNOS_DOMAIN_Product product = new VNOS_DOMAIN_Product();
    product.prices.elements.add(price);
    //When
    product.applyVAT();

    //Then
    System.assert(
      '1.50'.equals(product.prices.getPrice().amount()),
      product.prices.getPrice().amount() + ' should be equal to 1.50'
    );
  }
  @isTest
  static void compareToReturns1WhenTheOrderInGroupIsBigger() {
    //Given
    VNOS_DOMAIN_Product uzoMobile500MB = new VNOS_DOMAIN_Product();
    uzoMobile500MB.name('500 MB');
    uzoMobile500MB.orderInGroupe(1);

    VNOS_DOMAIN_Product uzoMobile1GB = new VNOS_DOMAIN_Product();
    uzoMobile1GB.name('1 GB');
    uzoMobile1GB.orderInGroupe(2);

    //When
    Integer result = uzoMobile1GB.compareTo(uzoMobile500MB);

    //Then
    System.assert(result == 1, result + ' != 1');
  }

  @isTest
  static void compareToReturns0WhenTheOrderInGroupIsTheSame() {
    //Given
    VNOS_DOMAIN_Product uzoMobile500MB = new VNOS_DOMAIN_Product();
    uzoMobile500MB.name('500 MB');
    uzoMobile500MB.orderInGroupe(1);

    VNOS_DOMAIN_Product uzoMobile1GB = new VNOS_DOMAIN_Product();
    uzoMobile1GB.name('1 GB');
    uzoMobile1GB.orderInGroupe(1);

    //When
    Integer result = uzoMobile1GB.compareTo(uzoMobile500MB);

    //Then
    System.assert(result == 0, result + ' != 0');
  }

  @isTest
  static void compareToReturnsMinus1WhenTheOrderInGroupIsSmaller() {
    //Given
    VNOS_DOMAIN_Product uzoMobile500MB = new VNOS_DOMAIN_Product();
    uzoMobile500MB.name('500 MB');
    uzoMobile500MB.orderInGroupe(2);

    VNOS_DOMAIN_Product uzoMobile1GB = new VNOS_DOMAIN_Product();
    uzoMobile1GB.name('1 GB');
    uzoMobile1GB.orderInGroupe(1);

    //When
    Integer result = uzoMobile1GB.compareTo(uzoMobile500MB);

    //Then
    System.assert(result == -1, result + ' != -1');
  }

  @isTest
  static void toResponse() {
    //Given
    VNOS_DOMAIN_CommercialAttribute data = new VNOS_DOMAIN_CommercialAttribute();
    data.isFromMatrix(true);
    data.value('1GB');
    data.isInput(true);

    VNOS_DOMAIN_Product uzoMobile500MB = new VNOS_DOMAIN_Product();
    uzoMobile500MB.name('500 MB');
    uzoMobile500MB.attributes.elements.add(data);

    //When
    Map<String, Object> response = uzoMobile500MB.toResponse();

    //Then
    System.assert(response != null, 'response should not be null');
    //TODO : should be better tested
  }

  @isTest
  static void duplicate() {
    //Given
    VNOS_DOMAIN_Product uzoMobile500MB = new VNOS_DOMAIN_Product();
    uzoMobile500MB.name('500 MB');

    //When
    VNOS_DOMAIN_Product duplicate = uzoMobile500MB.duplicate();

    //Then
    System.assert(
      duplicate.name().equals(uzoMobile500MB.name()),
      'the duplicate should have same values in the node'
    );
  }
} 
