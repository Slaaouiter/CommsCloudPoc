public class VNOS_DOMAIN_Offers {
  public List<VNOS_DOMAIN_Offer> elements = new List<VNOS_DOMAIN_Offer>();
  public List<Object> nodes = new List<Object>();

  public VNOS_DOMAIN_Offers() {
  }

  public VNOS_DOMAIN_Offers(List<Object> offers) {
    if (offers != null && !offers.isEmpty()) {
      this.nodes = offers;
      for (Object offer : offers) {
        this.elements.add(
          VNOS_FACTORY_Offer.createOffer((Map<String, Object>) offer)
        );
      }
    }
  }
  public VNOS_DOMAIN_Promotions getPromotions() {
    return new VNOS_DOMAIN_Promotions(elements);
  }
  public VNOS_DOMAIN_Products getProducts() {
    return new VNOS_DOMAIN_Products(elements);
  }
  public void applyVAT() {
    for (VNOS_DOMAIN_Offer offer : elements) {
      if (offer instanceof VNOS_DOMAIN_Product) {
        ((VNOS_DOMAIN_Product) offer).applyVAT();
      } else if (offer instanceof VNOS_DOMAIN_Promotion) {
        ((VNOS_DOMAIN_Promotion) offer).applyVAT();
      }
    }
  }
  public void add(VNOS_DOMAIN_Product product) {
    if (product != null && product.node != null) {
      this.nodes.add(product.node);
      this.elements.add(product);
    }
  }

  public void remove(VNOS_DOMAIN_Product product) {
    if (product != null && product.node != null) {
      removeFromElements(product);
      removeFromNodes(product.node);
    }
  }
  public void removeFromElements(VNOS_DOMAIN_Product product) {
    Integer index = this.elements.indexOf(product);
    if (index != -1) {
      this.elements.remove(index);
    }
  }
  public void removeFromNodes(Object node) {
    Integer index = this.nodes.indexOf(node);
    if (index != -1) {
      this.nodes.remove(index);
    }
  }
}