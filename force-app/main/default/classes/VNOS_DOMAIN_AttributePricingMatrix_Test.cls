@isTest
private class VNOS_DOMAIN_AttributePricingMatrix_Test {
  @isTest
  static void constructorCanCreateFromListOfCalculationMatrixRow() {
    //Given
    Map<String, Object> inputData = new Map<String, Object>();
    Map<String, Object> outputData = new Map<String, Object>();

    CalculationMatrixRow calculationMatrixRow = new calculationMatrixRow();
    calculationMatrixRow.InputData = JSON.serialize(inputData);
    calculationMatrixRow.OutputData = JSON.serialize(outputData);

    List<CalculationMatrixRow> calculationMatrixRows = new List<CalculationMatrixRow>();
    calculationMatrixRows.add(calculationMatrixRow);
    //When
    VNOS_DOMAIN_AttributePricingMatrixRows attributePricingMatrixRows = new VNOS_DOMAIN_AttributePricingMatrixRows(
      calculationMatrixRows
    );

    //Then
    System.assert(attributePricingMatrixRows.rows.size() == 1, 'Size !=1');
  }

  @isTest
  static void groupByProductCode() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow uzo6GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo6GB.sourceProductCode = 'UZO Móvel';
    uzo6GB.itemName = 'UZO 1000+6GB';

    VNOS_DOMAIN_AttributePricingMatrixRow uzo1GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo1GB.sourceProductCode = 'UZO Móvel';
    uzo1GB.itemName = 'UZO 500+1GB';

    VNOS_DOMAIN_AttributePricingMatrixRows attributePricingMatrixRows = new VNOS_DOMAIN_AttributePricingMatrixRows();
    attributePricingMatrixRows.rows.add(uzo1GB);
    attributePricingMatrixRows.rows.add(uzo6GB);
    //When
    Map<String, VNOS_DOMAIN_AttributePricingMatrixRows> groupedAttributePricingMatrixRowsByCode = attributePricingMatrixRows.groupByProductCode();

    //Then
    System.assert(
      groupedAttributePricingMatrixRowsByCode.size() == 1,
      'Size != 1'
    );
    System.assert(
      groupedAttributePricingMatrixRowsByCode.containsKey('UZO Móvel'),
      'Should contain UZO Móvel'
    );
  }

  @isTest
  static void filterByChannel() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow uzo6GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo6GB.sourceProductCode = 'UZO Móvel';
    uzo6GB.itemName = 'UZO 1000+6GB';
    uzo6GB.channels = 'Portal;Web';

    VNOS_DOMAIN_AttributePricingMatrixRow uzo1GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo1GB.sourceProductCode = 'UZO Móvel';
    uzo1GB.itemName = 'UZO 500+1GB';
    uzo1GB.channels = 'Portal';

    VNOS_DOMAIN_AttributePricingMatrixRows attributePricingMatrixRows = new VNOS_DOMAIN_AttributePricingMatrixRows();
    attributePricingMatrixRows.rows.add(uzo1GB);
    attributePricingMatrixRows.rows.add(uzo6GB);

    //When
    attributePricingMatrixRows.filterByChannel('Web');

    //Then
    System.assert(attributePricingMatrixRows.rows.size() == 1, 'Size != 1');
    System.assert(
      attributePricingMatrixRows.rows.get(0) == uzo6GB,
      'element uzo6GB should be in elements'
    );
  }

  @isTest
  static void filterByOrderable() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow uzo6GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo6GB.sourceProductCode = 'UZO Móvel';
    uzo6GB.itemName = 'UZO 1000+6GB';
    uzo6GB.channels = 'Portal;Web';
    uzo6GB.isOrderable = true;

    VNOS_DOMAIN_AttributePricingMatrixRow uzo1GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo1GB.sourceProductCode = 'UZO Móvel';
    uzo1GB.itemName = 'UZO 500+1GB';
    uzo1GB.channels = 'Portal';
    uzo1GB.isOrderable = false;

    VNOS_DOMAIN_AttributePricingMatrixRows attributePricingMatrixRows = new VNOS_DOMAIN_AttributePricingMatrixRows();
    attributePricingMatrixRows.rows.add(uzo1GB);
    attributePricingMatrixRows.rows.add(uzo6GB);

    //When
    attributePricingMatrixRows.filterByOrderable();

    //Then
    System.assert(attributePricingMatrixRows.rows.size() == 1, 'Size != 1');
    System.assert(
      attributePricingMatrixRows.rows.get(0) == uzo6GB,
      'element uzo6GB should be in elements'
    );
  }

  @isTest
  static void excludeByProductCode() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow uzo6GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo6GB.sourceProductCode = 'UZO Móvel';
    uzo6GB.itemName = 'UZO 1000+6GB';
    uzo6GB.channels = 'Portal;Web';

    VNOS_DOMAIN_AttributePricingMatrixRow uzo1GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo1GB.sourceProductCode = 'UZO Marca';
    uzo1GB.itemName = 'UZO 500+1GB';
    uzo1GB.channels = 'Portal';

    VNOS_DOMAIN_AttributePricingMatrixRows attributePricingMatrixRows = new VNOS_DOMAIN_AttributePricingMatrixRows();
    attributePricingMatrixRows.rows.add(uzo1GB);
    attributePricingMatrixRows.rows.add(uzo6GB);

    //When
    attributePricingMatrixRows.excludeByProductCode('UZO Móvel');

    //Then
    System.assert(attributePricingMatrixRows.rows.size() == 1, 'Size != 1');
    System.assert(
      attributePricingMatrixRows.rows.get(0) == uzo1GB,
      'element uzo1GB should remain in elements'
    );
  }

  @isTest
  static void toResponseGroupedByProductCode() {
    //Given
    VNOS_DOMAIN_AttributePricingMatrixRow uzo6GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo6GB.sourceProductCode = 'UZO Móvel';
    uzo6GB.itemName = 'UZO 1000+6GB';
    uzo6GB.channels = 'Portal;Web';

    VNOS_DOMAIN_AttributePricingMatrixRow uzo1GB = new VNOS_DOMAIN_AttributePricingMatrixRow();
    uzo1GB.sourceProductCode = 'UZO Marca';
    uzo1GB.itemName = 'UZO 500+1GB';
    uzo1GB.channels = 'Portal';

    VNOS_DOMAIN_AttributePricingMatrixRows attributePricingMatrixRows = new VNOS_DOMAIN_AttributePricingMatrixRows();
    attributePricingMatrixRows.rows.add(uzo1GB);
    attributePricingMatrixRows.rows.add(uzo6GB);

    //When
    Map<String, Object> response = attributePricingMatrixRows.toResponseGroupedByProductCode();

    //Then
    System.assert(response != null, 'response should not be null');
  }
}
