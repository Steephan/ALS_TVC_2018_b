rem ---
rem --- Processings steps
rem --- by Stephan Lange
rem --- last modified: 2021-10-22 by Inge Grünberg

rem --- 00 change directory ---
rem E:
rem cd ALS_TVC\ALS_TVC_2018_b

rem --- 01 prepare point cloud ---
rem Names of all flight lines
set F1=01_pointclouds\repaired\ALS_L1B_20180822T203942_204538_ascii.txt
set F2=01_pointclouds\repaired\ALS_L1B_20180822T204516_205246_ascii.txt
set F3=01_pointclouds\repaired\ALS_L1B_20180822T205223_205845_ascii.txt
set F4=01_pointclouds\repaired\ALS_L1B_20180822T205822_210426_ascii.txt
set F5=01_pointclouds\repaired\ALS_L1B_20180822T210404_211139_ascii.txt
set F6=01_pointclouds\repaired\ALS_L1B_20180822T211117_211745_ascii.txt
set F7=01_pointclouds\repaired\ALS_L1B_20180822T211720_212324_ascii.txt
set F8=01_pointclouds\repaired\ALS_L1B_20180822T212257_213043_ascii.txt
set F9=01_pointclouds\repaired\ALS_L1B_20180822T213020_213645_ascii.txt
set F10=01_pointclouds\repaired\ALS_L1B_20180822T213623_214359_ascii.txt
set F11=01_pointclouds\repaired\ALS_L1B_20180822T214336_215002_ascii.txt
set F12=01_pointclouds\repaired\ALS_L1B_20180822T214937_215542_ascii.txt
set F13=01_pointclouds\repaired\ALS_L1B_20180822T215519_220309_ascii.txt
set F14=01_pointclouds\repaired\ALS_L1B_20180822T220246_220915_ascii.txt
set F15=01_pointclouds\repaired\ALS_L1B_20180822T220852_221533_ascii.txt
set F16=01_pointclouds\repaired\ALS_L1B_20180822T221422_222210_ascii.txt
set F17=01_pointclouds\repaired\ALS_L1B_20180822T222148_222809_ascii.txt
set F18=01_pointclouds\repaired\ALS_L1B_20180822T222746_223513_ascii.txt
set F19=01_pointclouds\repaired\ALS_L1B_20180822T223441_224100_ascii.txt
set F20=01_pointclouds\repaired\ALS_L1B_20180822T224036_224649_ascii.txt
set F21=01_pointclouds\repaired\ALS_L1B_20180822T224626_225353_ascii.txt
set F22=01_pointclouds\repaired\ALS_L1B_20180822T225328_225947_ascii.txt
set F23=01_pointclouds\repaired\ALS_L1B_20180822T225921_230525_ascii.txt
set F24=01_pointclouds\repaired\ALS_L1B_20180822T230503_231231_ascii.txt
set F25=01_pointclouds\repaired\ALS_L1B_20180822T231207_231829_ascii.txt
set F26=01_pointclouds\repaired\ALS_L1B_20180822T231817_233012_ascii.txt
set F27=01_pointclouds\repaired\ALS_L1B_20180822T233027_233853_ascii.txt
set F28=01_pointclouds\repaired\ALS_L1B_20180822T234105_234454_ascii.txt
set F29=01_pointclouds\repaired\ALS_L1B_20180822T234816_235244_ascii.txt
set F30=01_pointclouds\repaired\ALS_L1B_20180822T235531_240058_ascii.txt
rem Import single ALS strips
opalsImport -inf %F1% %F2% %F3% %F4% %F5% %F6% %F7% %F8% %F9% %F10% %F11% %F12% %F13% %F14% %F15% %F16% %F17% %F18% %F19% %F20% %F21% %F22% %F23% %F24% %F25% %F26% %F27% %F28% %F29% %F30% -outf 02_intermediate\ALS_all.odm -iformat iformat_raw_withHeader.xml -tilesize 150.0

rem --- 02 process point cloud ---
rem Add EchoRank 
opalsAddInfo -inf 02_intermediate\ALS_all.odm -points_in_memory 5000000 -attribute _EchoRank(unsignedByte)=_EchoCount-EchoNumber
rem Export point cloud of study area
opalsExport -inf 02_intermediate\ALS_all.odm -outf 02_intermediate\ALS1_all_basic.txt -oformat oformat_basic.xml -filter "Region[03_region\new_study_area.shp]"
rem opalsExport -inf 02_intermediate\ALS_all.odm -outf 02_intermediate\ALS1_all_basic.txt -oformat oformat_basic.xml -filter "Region[03_region\region_ALS2016.shp]"

rem --- 03 classify echo types and drop other columns ---
python classifyEchoType1.py 
rem python script creates ALS1_all_echotypes.txt
opalsImport -inf 02_intermediate\ALS1_all_echotypes.txt -outf 02_intermediate\ALS1_all_echotypes.odm -iformat iformat_echotypes.xml -tilesize 80.0
opalsCell -inf 02_intermediate\ALS1_all_echotypes.odm -outFile 04_rasters\ALS1_all_echotypes_pcount.tif -feature pcount -cel 1.0

rem --- 04 terrain probability ---
rem filter by echo type 
rem first and middle with constant terrainprob of 0%
opalsExport -inf 02_intermediate\ALS1_all_echotypes.odm -outf 02_intermediate\ALS_first_echotypes_SOR.txt -filter "Generic[_EchoType == 1 OR _EchoType == 2]" -oformat oformat_echotypes.xml
opalsImport -inf 02_intermediate\ALS_first_echotypes_SOR.txt -outf 02_intermediate\ALS_first_echotypes_SOR.odm -iformat iformat_echotypes.xml -tilesize 120.0
opalsAddInfo -inf 02_intermediate\ALS_first_echotypes_SOR.odm -attribute "_terrainProb = 0.0"
opalsExport -inf 02_intermediate\ALS_first_echotypes_SOR.odm -outf 02_intermediate\ALS_first_echotypes_SOR_terrainprob.txt -oformat oformat_terrainprob.xml
opalsImport -inf 02_intermediate\ALS_first_echotypes_SOR_terrainprob.txt -outf 02_intermediate\ALS_first_echotypes_SOR_terrainprob_1.odm -iformat iformat_terrainprob_first.xml -tilesize 80.0

rem single and last with terrainprob python calculation
opalsExport -inf 02_intermediate\ALS1_all_echotypes.odm -outf 02_intermediate\ALS_last_echotypes_SOR.txt -filter "Generic[_EchoType == 0 OR _EchoType == 3]" -oformat oformat_echotypes.xml
set PYPATH=C:\python_2_opals\python.exe
python terrainProbability2pi.py 02_intermediate\ALS_last_echotypes_SOR.txt 4 5 10000000
rem creates ALS_last_echotypes_SOR_terrainprob_last.txt
opalsImport -inf 02_intermediate\ALS_last_echotypes_SOR_terrainprob_last.txt -outf 02_intermediate\ALS_last_echotypes_SOR.odm -iformat iformat_terrainProb.xml -tilesize 80.0

rem merge both odms again
opalsImport -inf 02_intermediate\ALS_last_echotypes_SOR.odm 02_intermediate\ALS_first_echotypes_SOR_terrainprob_1.odm -outf 02_intermediate\ALS_last_echotypes_SOR.odm

rem --- 05 DTM generation using OPALS (DTM module) ---
set COORD=-coord_ref_sys EPSG:32608

rem RobFilter
opalsRobFilter -inFile 02_intermediate\ALS_last_echotypes_SOR.odm -debugOutFile 02_intermediate\ALS1_all_echotypes_SOR_terrainprob_grdPts.xyz -points_in_memory 16000000 -filter "Generic[_TerrainProb>0.0]" -sigmaApriori "_TerrainProb>0.5 ? 0.25 : 0.5"
opalsGrid -inFile 02_intermediate\ALS_last_echotypes_SOR.odm -outFile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m.tif -interpolation robMovingPlanes -gridSize 1.0 -searchRad 7.5 -filter class[ground] %COORD% 
opalsShade -inFile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m.tif -outf 04_rasters\shd_ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m.tif -pixelsize 1.0 %COORD% 

rem fill DTM
opalsStatFilter -inFile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m.tif -outFile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_smooth.tif -feature mean -kernelSize 3 %COORD% 
opalsAlgebra -inFile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m.tif 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_smooth.tif -outFile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_filled.tif -formula "return r[1] if ( r[0] is None) else r[0]" -gridSize 1.0 %COORD% 
opalsShade -inFile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_filled.tif -outFile 04_rasters\shd_ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_filled.tif -pixelsize 1.0 %COORD% 

rem --- 06 Veg. height generation using OPALS (AddInfo & Cell modules) ---

rem compute vegetation height: Z - DTM
opalsAddInfo -inf 02_intermediate\ALS_last_echotypes_SOR.odm -gridfile 04_rasters\ALS1_all_echotypes_SOR_terrain_RobF_robMovPlanes_1m_filled.tif -attribute _nZ=Z-r[0]
opalsAddInfo -inf 02_intermediate\ALS_last_echotypes_SOR.odm -attribute "_nZ_corr = _nZ <0.0 ? 0.0 : _nZ"

rem filter point cloud by threshold of 20 m above ground
opalsExport -inf 02_intermediate\ALS_last_echotypes_SOR.odm -outf 02_intermediate\ALS1_all_echotypes_SOR_terrain.txt  -filter "Generic[_nZ <= 20]" -oformat oformat_all.xml

set PYPATH=C:\python_2_opals\python.exe
python classifyVegType.py
rem output ALS1_all_echotypes_SOR_terrain_classified.txt
opalsImport -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.txt -outf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -iformat iformat_all.xml -tilesize 120.0

rem output vegHeight rasters
opalsCell -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_nZ_max_1m.tif -cellsize 1.0 -attribute _nZ_corr -feature max %COORD% -filter "Generic[_nZ_corr> 0.0]"
opalsCell -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_nZ_mean_1m.tif -cellsize 1.0 -attribute _nZ_corr -feature mean %COORD% -filter "Generic[_nZ_corr> 0.0]"
opalsCell -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_nZ_q99_1m.tif -cellsize 1.0 -attribute _nZ_corr -feature quantile:0.99 %COORD% -filter "Generic[_nZ_corr> 0.0]"
opalsCell -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_nZ_q95_1m.tif -cellsize 1.0 -attribute _nZ_corr -feature quantile:0.95 %COORD% -filter "Generic[_nZ_corr> 0.0]"

rem fill vegHeight rasters
rem mean
opalsStatFilter -inFile 04_rasters\ALS_all_echotypes_SOR_nZ_mean_1m.tif -outFile 04_rasters\ALS_all_echotypes_SOR_nZ_mean_1m_smooth.tif -feature mean -kernelSize 3 %COORD%
opalsAlgebra -inFile 04_rasters\ALS_all_echotypes_SOR_nZ_mean_1m.tif 04_rasters\ALS_all_echotypes_SOR_nZ_mean_1m_smooth.tif -outFile 04_rasters\ALS_all_echotypes_SOR_nZ_mean_1m_filled.tif -formula "return r[1] if ( r[0] is None) else r[0]" -gridSize 1.0 %COORD%
rem max
opalsStatFilter -inFile 04_rasters\ALS_all_echotypes_SOR_nZ_max_1m.tif -outFile 04_rasters\ALS_all_echotypes_SOR_nZ_max_1m_smooth.tif -feature mean -kernelSize 3 %COORD%
opalsAlgebra -inFile 04_rasters\ALS_all_echotypes_SOR_nZ_max_1m.tif 04_rasters\ALS_all_echotypes_SOR_nZ_max_1m_smooth.tif -outFile 04_rasters\ALS_all_echotypes_SOR_nZ_max_1m_filled.tif -formula "return r[1] if ( r[0] is None) else r[0]" -gridSize 1.0 %COORD%

rem --- 7 Export point cloud ---
opalsExport -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_check\TVC_ALS_2018.laz -oformat oformat_pangaea_las.xml 

rem --- 8 Generate rasters of amplitude and echo width ---
opalsGrid -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_amplitude_1m.tif -interpolation robMovingPlanes -gridSize 1.0 -searchRad 7.5 -attribute Amplitude %COORD%
opalsCell -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_amplitude_max_1m.tif -cellsize 1.0 -attribute Amplitude -feature max %COORD%
opalsGrid -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_echowidth_1m.tif -interpolation robMovingPlanes -gridSize 1.0 -searchRad 7.5 -attribute EchoWidth %COORD%
opalsCell -inf 02_intermediate\ALS1_all_echotypes_SOR_terrain_classified.odm -outf 04_rasters\ALS_all_echotypes_SOR_echowidth_max_1m.tif -cellsize 1.0 -attribute EchoWidth -feature max %COORD%

rem fill mean and max amplitude and echowidth rasters
rem mean amplitude
opalsStatFilter -inFile 04_rasters\ALS_all_echotypes_SOR_amplitude_1m.tif -outFile 04_rasters\ALS_all_echotypes_SOR_amplitude_1m_smooth.tif -feature mean -kernelSize 3 %COORD%
opalsAlgebra -inFile 04_rasters\ALS_all_echotypes_SOR_amplitude_1m.tif 04_rasters\ALS_all_echotypes_SOR_amplitude_1m_smooth.tif -outFile 04_rasters\ALS_all_echotypes_SOR_amplitude_1m_filled.tif -formula "return r[1] if ( r[0] is None) else r[0]" -gridSize 1.0 %COORD%
rem max amplitude
opalsStatFilter -inFile 04_rasters\ALS_all_echotypes_SOR_amplitude_max_1m.tif -outFile 04_rasters\ALS_all_echotypes_SOR_amplitude_max_1m_smooth.tif -feature mean -kernelSize 3 %COORD%
opalsAlgebra -inFile 04_rasters\ALS_all_echotypes_SOR_amplitude_max_1m.tif 04_rasters\ALS_all_echotypes_SOR_amplitude_max_1m_smooth.tif -outFile 04_rasters\ALS_all_echotypes_SOR_amplitude_max_1m_filled.tif -formula "return r[1] if ( r[0] is None) else r[0]" -gridSize 1.0 %COORD%
rem mean echo width
opalsStatFilter -inFile 04_rasters\ALS_all_echotypes_SOR_echowidth_1m.tif -outFile 04_rasters\ALS_all_echotypes_SOR_echowidth_1m_smooth.tif -feature mean -kernelSize 3 %COORD%
opalsAlgebra -inFile 04_rasters\ALS_all_echotypes_SOR_echowidth_1m.tif 04_rasters\ALS_all_echotypes_SOR_echowidth_1m_smooth.tif -outFile 04_rasters\ALS_all_echotypes_SOR_echowidth_1m_filled.tif -formula "return r[1] if ( r[0] is None) else r[0]" -gridSize 1.0 %COORD%
rem max echo width
opalsStatFilter -inFile 04_rasters\ALS_all_echotypes_SOR_echowidth_max_1m.tif -outFile 04_rasters\ALS_all_echotypes_SOR_echowidth_max_1m_smooth.tif -feature mean -kernelSize 3 %COORD%
opalsAlgebra -inFile 04_rasters\ALS_all_echotypes_SOR_echowidth_max_1m.tif 04_rasters\ALS_all_echotypes_SOR_echowidth_max_1m_smooth.tif -outFile 04_rasters\ALS_all_echotypes_SOR_echowidth_max_1m_filled.tif -formula "return r[1] if ( r[0] is None) else r[0]" -gridSize 1.0 %COORD%

