public class VNOS_DOMAIN_Price {
  @TestVisible
  private static final String CONST_ONE_TIME = 'One-time';
  @TestVisible
  private static final String CONST_RECURRING = 'Recurring';
  @TestVisible
  private static final String CONST_CHARGE_TYPE = 'ChargeType__c';
  @TestVisible
  private static final String CONST_CHARGE_AMOUNT = 'chargeamount';
  @TestVisible
  private static final String CONST_AMOUNT = 'Amount__c';
  @TestVisible
  private static final String CONST_INITIAL_AMOUNT = 'initialAmount';

  public Map<String, Object> node = new Map<String, Object>();

  public VNOS_DOMAIN_Price() {
  }

  public VNOS_DOMAIN_Price(Map<String, Object> price) {
    if (price != null) {
      this.node = price;
    }
  }

  public String initialAmount() {
    return String.valueOf(node.get(CONST_INITIAL_AMOUNT));
  }

  public void initialAmount(String initialAmount) {
    node.put(CONST_INITIAL_AMOUNT, initialAmount);
  }

  public String amount() {
    return String.valueOf(node.get(CONST_AMOUNT));
  }
  public void amount(String amount) {
    node.put(CONST_AMOUNT, amount);
  }

  public String chargeAmount() {
    return String.valueOf(node.get(CONST_CHARGE_AMOUNT));
  }
  public void chargeAmount(String chargeAmount) {
    node.put(CONST_CHARGE_AMOUNT, chargeAmount);
  }

  public String chargeType() {
    return String.valueOf(node.get(CONST_CHARGE_TYPE));
  }
  public Boolean isOneTimeCharge() {
    return CONST_ONE_TIME.equals(chargeType());
  }
  public Boolean isRecurringCharge() {
    return CONST_RECURRING.equals(chargeType());
  }

  public void applyPromotion(VNOS_DOMAIN_Promotion promotion) {
    try {
      Decimal amount = Decimal.valueOf(amount());
      Decimal chargeAmount = Decimal.valueOf(promotion.price.chargeAmount());
      Decimal result = amount + chargeAmount;
      amount(result.toPlainString());
    } catch (Exception e) {
      System.debug(
        'applyPromotion : error occured trying to apply the promotion' +
          promotion.name() +
          'with the charge amount :' +
          promotion.price.chargeAmount() +
          'to the amount :' +
          amount()
      );
    }
  }

  public void applyVAT() {
    if (!String.isEmpty(amount())) {
      Decimal amountWithVAT = applyVAT(Decimal.valueOf(amount()));
      amount(amountWithVAT.toPlainString());
    }
    if (!String.isEmpty(chargeAmount())) {
      Decimal chargeAmountWithVAT = applyVAT(Decimal.valueOf(chargeAmount()));
      chargeAmount(chargeAmountWithVAT.toPlainString());
    }
  }

  public Decimal applyVAT(Decimal amountWithoutVat) {
    if (amountWithoutVat == null) {
      return 0;
    }
    return (amountWithoutVat * 1).setScale(2, System.RoundingMode.HALF_UP);
  }
  public VNOS_DOMAIN_Price duplicate() {
    return new VNOS_DOMAIN_Price(
      (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(node))
    );
  }
}
