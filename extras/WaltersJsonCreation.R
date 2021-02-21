# example json creation:

createdBy <- 'Henrik John'
organizationName <- 'Erasmus University Medical Center'
outputLocation <- '~/Desktop'

baseUrl <- Sys.getenv('baseUrl')

settings <- data.frame(targetCohortId = c(18210),
                       targetCohortName = c('Walters Target 0 Prior 0 Post'),
                       outcomeId = c(7414),
                       outcomeName = c('Persons with dementia'))


populationSetting <- PatientLevelPrediction::createStudyPopulationSettings(binary = T,
                                                                           includeAllOutcomes = F, 
                                                                           firstExposureOnly = T, 
                                                                           washoutPeriod = 365, 
                                                                           removeSubjectsWithPriorOutcome = T, 
                                                                           priorOutcomeLookback = 9999, 
                                                                           requireTimeAtRisk = T, 
                                                                           minTimeAtRisk = 365, 
                                                                           riskWindowStart = 1, 
                                                                           startAnchor = 'cohort start', 
                                                                           endAnchor = 'cohort start', 
                                                                           riskWindowEnd = 365*5, 
                                                                           verbosity = 'INFO')

modelList <- list()
#length(modelList) <- 2
modelList[[1]] <- createModelJson(modelname = 'walters_dementia_model', 
                                  modelFunction = 'glm',
                                  standardCovariates = NULL,
                                  cohortCovariateSettings = list(atlasCovariateIds = c(18203,
                                                                                       19820,
                                                                                       18205,
                                                                                       18207,
                                                                                       18206,
                                                                                       18208,
                                                                                       19842, #18229,
                                                                                       18230,
                                                                                       18284,
                                                                                       18282,
                                                                                       18283,
                                                                                       18224),
                                                                 atlasCovariateNames = c('BMI',
                                                                                         'BMI squared',
                                                                                         'Smoking status never',
                                                                                         'Smoking status past',
                                                                                         'Smoking status current',
                                                                                         'History of alcohol problem',
                                                                                         'History of diabetes',
                                                                                         'Depression',
                                                                                         'Stroke',
                                                                                         'Atrial fibrillation',
                                                                                         'Current aspirin use',
                                                                                         'Social deprivation'),
                                                                 analysisIds = rep(456, 12),
                                                                 startDays = c(-365,
                                                                               -365,
                                                                               -1825,
                                                                               -1825,
                                                                               -1825,
                                                                               -9999,
                                                                               -9999,
                                                                               -365,
                                                                               -9999,
                                                                               -9999,
                                                                               -365,
                                                                               -365),
                                                                 endDays = c(0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0,
                                                                             0),
                                                                 points = c(-0.0616,
                                                                            0.002508,
                                                                            0.0,
                                                                            -0.06792,
                                                                            -0.08657,
                                                                            0.443535,
                                                                            0.286701,
                                                                            0.833612,
                                                                            0.577207,
                                                                            0.220728,
                                                                            0.252833,
                                                                            0.225529),
                                                                 count = rep(F, length(points)),
                                                                 ageInteraction = rep(F, length(points)),
                                                                 lnAgeInteraction = rep(F, length(points))
                                  ),
                                  
                                  measurementCovariateSettings = NULL, 
                                  measurementCohortCovariateSettings = NULL, 
                                  ageCovariateSettings = NULL,
                                  
                                  finalMapping = 'function(x){xTemp = x; xTemp[x==0] <- 0.039; xTemp[x==1] <- 0.06;xTemp[x==2] <- 0.101;xTemp[x>=3] <- 0.15;return(xTemp) }',
                                  predictionType = 'survival'
)


jsonSet <- createStudyJson(packageName = 'EmcWaltersDementiaModelJson',
                packageDescription = 'Walters model',
                createdBy = createdBy ,
                organizationName = organizationName,
                settings = settings,
                baseUrl = baseUrl,
                populationSetting = populationSetting ,
                modelList = modelList,
                outputLocation = outputLocation)


jsonSet <- Hydra::loadSpecifications(file.path(outputLocation,'existingModelSettings.json'))
Hydra::hydrate(specifications = jsonSet, 
               outputFolder = '~/Desktop')

