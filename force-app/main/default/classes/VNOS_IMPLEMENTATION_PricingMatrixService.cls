public class VNOS_IMPLEMENTATION_PricingMatrixService implements VNOS_INTERFACE_PricingMatrixService {
  private static final String HEADER = 'Header';

  private static VNOS_IMPLEMENTATION_PricingMatrixService instance;
  private MatrixRowsMapper mapper = new MatrixRowsMapper();

  private VNOS_IMPLEMENTATION_PricingMatrixService() {}

  public static VNOS_IMPLEMENTATION_PricingMatrixService getInstance() {
    if (instance == null) {
      instance = new VNOS_IMPLEMENTATION_PricingMatrixService();
    }
    return instance;
  }

  @TestVisible
  private CalculationMatrixVersion getLatestCalculationMatrixVersion(String matrixName) {
    try {
      return [
        Select Id, CalculationMatrix.Name,Rank 
        FROM CalculationMatrixVersion 
        WHERE CalculationMatrix.Name =:matrixName 
        AND IsEnabled = TRUE 
        AND StartDateTime < TODAY 
        AND(
          EndDateTime > TODAY  
          OR EndDateTime = null
        )
        ORDER BY Rank DESC LIMIT 1
      ];
    } catch (Exception e) {
      System.debug('Warning - Pricing Matrix Service, getLatestCalculationMatrixVersion  an exception occured while quering the latest calculation matrix version with name '+ matrixName +' : exception message => ' + e.getMessage());
      return null;
    }
  }

  @TestVisible
  public List<CalculationMatrixRow> getCalculationMatrixRows(Id versionId) {
    try {
      return [
        SELECT Id, Name, InputData, OutputData
        FROM CalculationMatrixRow
        WHERE Name != :HEADER 
        AND CalculationMatrixVersionId = :versionId
      ];
    } catch (Exception e) {
      System.debug('Warning - Pricing Matrix Service, getCalculationMatrixRows  an exception occured while quering calculation matrix rows for  version with id '+ versionId +' : exception message => ' + e.getMessage());
      return new List<CalculationMatrixRow>();
    }
    
  }
  
  public VNOS_DOMAIN_AttributePricingMatrixRows getAttributePricingMatrixRows(String attributeMatrixName){
    VNOS_DOMAIN_AttributePricingMatrixRows rows = new VNOS_DOMAIN_AttributePricingMatrixRows();
      CalculationMatrixVersion calculationMatrixVersion = getLatestCalculationMatrixVersion(attributeMatrixName);

      if(calculationMatrixVersion != null){
        List<CalculationMatrixRow> calculationMatrixRows = getCalculationMatrixRows(calculationMatrixVersion.Id);
        rows = mapper.fromCalculationMatrixRowsToDomain(calculationMatrixRows); 
    }

    return rows;
  }

  class MatrixRowsMapper{
    public VNOS_DOMAIN_AttributePricingMatrixRows fromCalculationMatrixRowsToDomain(List<CalculationMatrixRow> calculationMatrixRows){
      return new VNOS_DOMAIN_AttributePricingMatrixRows(calculationMatrixRows);
    }
  }
}