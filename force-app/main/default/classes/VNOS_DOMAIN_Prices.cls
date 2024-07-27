public class VNOS_DOMAIN_Prices {
  public List<VNOS_DOMAIN_Price> elements = new List<VNOS_DOMAIN_Price>();

  public VNOS_DOMAIN_Prices() {
  }

  public VNOS_DOMAIN_Prices(List<Object> nodes) {
    if (nodes != null) {
      for (Object node : nodes) {
        if (node instanceof Map<String, Object>) {
          Map<String, Object> priceMap = (Map<String, Object>) node;
          VNOS_DOMAIN_Price price = new VNOS_DOMAIN_Price(priceMap);
          elements.add(price);
        }
      }
    }
  }

  public void updateAmountsFromMatrixRow(
    VNOS_DOMAIN_AttributePricingMatrixRow row
  ) {
    VNOS_DOMAIN_Price price = getPrice();
    String newPrice = price.isRecurringCharge() ? row.mrc : row.nrc;
    price.amount(newPrice);
  }

  public VNOS_DOMAIN_Price getPrice() {
    return !elements.isEmpty() ? elements.get(0) : new VNOS_DOMAIN_Price();
  }
}