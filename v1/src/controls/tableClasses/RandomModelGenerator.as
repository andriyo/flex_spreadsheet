package controls.tableClasses
{
	import model.Spreadsheet;
	
	public class RandomModelGenerator
	{
		private static var dimX:int;
		private static var dimY:int;
		
		private static var xmlTemplate : XML = 
					<workbook>
						<fileversion />
						<styles>
							<style id='1'>
								<s typeName='size' value='20'/>
							</style>
							<style id='2' parentStyle='1'>
								<s typeName='bold' value='1' startIndex='2' endIndex='4'/>
							</style>
							<style id='3' parentStyle='2'>
								<s typeName='color' value='0x00ff00' startIndex='3' endIndex='6'/>
							</style>
							<style id='4'>
								<s typeName='italic' value='1'/>
							</style>
						</styles>
							<sheets>
								<sheet id='1' name='sheet1' rowsCount='100' columnsCount='100'>
									<selection activeCell='B6'/>
									<cols>
										<col min="3" max="3" styleId="1"/> 
										<col min="4" max="4" width="40"/> 
										<col min="6" max="7" width="30"/>
									</cols>
									<sheetData>
										<row r='3'>
											<c r='3' styleId="3">
												<v>1Hello World! Hahhaa</v>
											</c>
										</row>
										<row r='4'>
											<c r='3'>
												<v>2</v>
											</c>
										</row>
										<row r='5' ht='50'>
											<c r='3'>
												<v>2Hello World! Hahhaa</v>
											</c>
										</row>
										<row r='6' styleId='4'>
											<c r='3'>
												<f>SUM(B3:B5)</f>
												<v>3Hello World! Hahhaa</v>
											</c>
										</row>
									</sheetData>	
								</sheet>
							</sheets>	
					</workbook>;
				
		static public function loadTemplate():Spreadsheet
		{
			var tre : Spreadsheet = Spreadsheet.loadFromXML(xmlTemplate); 		
			return Spreadsheet.loadFromXML(xmlTemplate);
		}
	}
	
}
