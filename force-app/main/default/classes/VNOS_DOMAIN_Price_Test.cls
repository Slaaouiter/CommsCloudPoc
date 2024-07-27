@isTest
private class VNOS_DOMAIN_Price_Test {
  @isTest
  static void constructor() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(VNOS_DOMAIN_Price.CONST_CHARGE_AMOUNT, 7.50);

    //When
    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);

    //Then
    System.assert(
      price != null &&
        price.node != null &&
        price.node.containsKey(VNOS_DOMAIN_Price.CONST_CHARGE_AMOUNT),
      'Constructor need to copy the map parameter in the node variable'
    );
  }

  @isTest
  static void initialAmountGetter() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(VNOS_DOMAIN_Price.CONST_INITIAL_AMOUNT, 6.5);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    String initialAmount = price.initialAmount();

    //Then
    System.assert(
      initialAmount.equals('6.5'),
      'initial amount :' + initialAmount + ' != 6.5'
    );
  }

  @isTest
  static void initialAmountSetter() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(VNOS_DOMAIN_Price.CONST_INITIAL_AMOUNT, 6.5);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    price.initialAmount('7');

    //Then
    System.assert(
      price.initialAmount().equals('7'),
      'initial amount :' + price.initialAmount() + ' != 7'
    );
  }

  @isTest
  static void amountGetter() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(VNOS_DOMAIN_Price.CONST_AMOUNT, 10);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    String amount = price.amount();

    //Then
    System.assert(amount.equals('10'), 'amount :' + amount + ' != 10');
  }

  @isTest
  static void amountSetter() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(VNOS_DOMAIN_Price.CONST_AMOUNT, 10);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    price.amount('20');

    //Then
    System.assert(
      price.amount().equals('20'),
      'amount' + price.amount() + ' != 20'
    );
  }

  @isTest
  static void chargeAmountGetter() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(VNOS_DOMAIN_Price.CONST_CHARGE_AMOUNT, 15);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    String chargeAmount = price.chargeAmount();

    //Then
    System.assert(
      chargeAmount.equals('15'),
      'amount :' + chargeAmount + '!= 15'
    );
  }

  @isTest
  static void chargerAmountSetter() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(VNOS_DOMAIN_Price.CONST_CHARGE_AMOUNT, 15);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    price.chargeAmount('20');

    //Then
    System.assert(
      price.chargeAmount().equals('20'),
      'charge amount ' + price.chargeAmount() + '!= 20'
    );
  }

  @isTest
  static void chargerTypeGetter() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_RECURRING
    );

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    String chargeType = price.chargeType();

    //Then
    System.assert(
      chargeType.equals(VNOS_DOMAIN_Price.CONST_RECURRING),
      'charge type: ' + chargeType + ' != recurring'
    );
  }

  @isTest
  static void isOneTimeChargeReturnFalseWhenTheChargeTypeIsNotOneTime() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_RECURRING
    );

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    Boolean isOneTimeCharge = price.isOneTimeCharge();

    //Then
    System.assert(!isOneTimeCharge, isOneTimeCharge + ' != false');
  }

  @isTest
  static void isOneTimeChargeReturnTrueWhenTheChargeTypeIsOneTime() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_ONE_TIME
    );

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    Boolean isOneTimeCharge = price.isOneTimeCharge();

    //Then
    System.assert(isOneTimeCharge, isOneTimeCharge + '!= true');
  }

  @isTest
  static void isRecurringChargeReturnFalseWhenTheChargeTypeIsNotRecurring() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_ONE_TIME
    );

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    Boolean isRecurringCharge = price.isRecurringCharge();

    //Then
    System.assert(!isRecurringCharge, isRecurringCharge + '!= false');
  }

  @isTest
  static void isRecurringChargeReturnTrueWhenTheChargeTypeIsRecurring() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_RECURRING
    );

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);
    //When
    Boolean isRecurringCharge = price.isRecurringCharge();

    //Then
    System.assert(isRecurringCharge, isRecurringCharge + '!= true');
  }

  @isTest
  static void applyPromotion() {
    //Given
    VNOS_DOMAIN_Price promotionAdjustment = new VNOS_DOMAIN_Price();
    promotionAdjustment.chargeAmount('-10.50');

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.price = promotionAdjustment;

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();
    price.amount('20.50');

    //When
    price.applyPromotion(promotion);

    //Then
    System.assert(
      '10.00'.equals(price.amount()),
      'amount : ' + price.amount() + ' != 10'
    );
  }

  @isTest
  static void applyPromotionDoesNothingIfAmountIsMalFormatted() {
    //Given
    VNOS_DOMAIN_Price promotionAdjustment = new VNOS_DOMAIN_Price();
    promotionAdjustment.chargeAmount('-10.5MAL');

    VNOS_DOMAIN_Promotion promotion = new VNOS_DOMAIN_Promotion();
    promotion.price = promotionAdjustment;

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();
    price.amount('20.50');

    //When
    price.applyPromotion(promotion);

    //Then
    System.assert(
      '20.50'.equals(price.amount()),
      'amount : ' + price.amount() + ' != 20.50'
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
    node.put(VNOS_DOMAIN_Price.CONST_CHARGE_AMOUNT, 1.6260);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);

    //When
    price.applyVAT();

    //Then
    System.assert(
      '1.50'.equals(price.amount()),
      price.amount() + ' should be equal to 1.50'
    );
    System.assert(
      '2.00'.equals(price.chargeAmount()),
      price.chargeAmount() + ' should be equal to 1.50'
    );
  }

  @isTest
  static void applyVATReturn0WhenAmountIsNull() {
    //Given
    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price();

    //When
    Decimal result = price.applyVAT(null);

    //Then
    System.assert(result == 0, 'result should be equal 0');
  }

  @isTest
  static void duplicate() {
    //Given
    Map<String, Object> node = new Map<String, Object>();
    node.put(
      VNOS_DOMAIN_Price.CONST_CHARGE_TYPE,
      VNOS_DOMAIN_Price.CONST_ONE_TIME
    );
    node.put(VNOS_DOMAIN_Price.CONST_AMOUNT, 7.50);

    VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(node);

    //When
    VNOS_DOMAIN_Price duplicate = price.duplicate();

    //Then
    System.assert(
      duplicate.node != null && !duplicate.node.isEmpty(),
      'Node was not duplicated'
    );
    System.assert(
      duplicate.amount().equals(price.amount()),
      'duplicat amount != price amount'
    );
  }
}
