global class VNOS_HOOK_GetOffersHandler implements vlocity_cmt.VlocityOpenInterface {
    private static final String CONST_OOTB = 'ootb';
  
    private final VNOS_INTERFACE_GetOffersHandler getOffersHandler = VNOS_IMPLEMENTATION_GetOffersHandler.getInstance();
    private vlocity_cmt.VlocityOpenInterface vlocityOpenInterface = (vlocity_cmt.VlocityOpenInterface) vlocity_cmt.VOIInvoker.getInstance().invoke('DefaultGetOffersRHandler', 'debugCreate', null, null, null);
  
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
  
      callOutOfTheBoxGetOffer(methodName, inputMap, outputMap, options);
  
      if(isOutOfTheBoxOnly(inputMap)){
          return true;
      }
  
      VNOS_DOMAIN_Offers offers = getOffersHandler.constructOffersFromResponse(
        outputMap
      );
  
      getOffersHandler.multiplyProductsByAttributePricingMatrixRows(offers,'AttributePricingMatrix');
  
      offers.applyVAT();
  
      getOffersHandler.putPromotionsInsideProducts(offers.getPromotions(),offers.getProducts());
  
      offers.getProducts().autoApplyPromotionsAtBrowseOffer();
  
      outputMap.put('offers', offers.getProducts().toResponse());
  
      return true;
    }
  
    private void callOutOfTheBoxGetOffer(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
      vlocityOpenInterface.invokeMethod(methodName, inputMap, outputMap, options);
    }
  
    private Boolean isOutOfTheBoxOnly(Map<String, Object> inputMap) {
      return inputMap != null && inputMap.containsKey(CONST_OOTB);
    }
  }