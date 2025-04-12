#### How is heart disease defined?

+ UCI dataset stems from /angiographic results/, that is, imaging of the coronary arteries
+ Heart disease is defined as the presence of significant narrowing (stenosis), usually 50%+, in the coronary arteries
+ Coronary artery disease (CAD) most common form of heart disease
+ Early identification helps prevent heart attacks and allows targeted intervention (stenting, lifestyle changes)

#### Why is heart disease "bad"?

+ No. 1 leading cause of death worldwide, more than any other condition GLOBALLY
+ Accounts for 1 in 5 deaths in the US
+ Accounts for 1 in 8 men and 1 in 14 women, slightly behind alzheimers/dementia [british heart foundation factsheet]
+ Eventually leads to serious outcomes such as heart attacks, heart failure, stroke, and sudden cardiac death
+ Develops silently over years with no symptoms, usually find out from first heart attack
+ Reduces quality of life by limiting physical activity, fatigue, shortness of breath, chest pain, and even long-term disability or hospitalization
+ Can be preventable but usually underdiagnosed and undertreated in younger people, women, and minority communities

#### What is the significance of our models?

+ Heart disease is preventable (via medication, treatments, and lifestyle changes), however, getting screened can be expensive or [annoying] which adds to the underdiagnosed and undertreated figures particularly in more vulnerable populations
+ If doctors were to collect easier measurements (such as resting heart rate, cholesterol levels, etc.) in a regular checkup appointment, they could then run these measurements into our model and compare
+ The limitation is that our model trained on Cleaveland hospital data in the United States from 1988:
  - Food and drug regulations have changed since then to account for new chemicals in food production, which could influence the measurements doctors seek to collect (either positively or negatively)
  - Cultural differences in exercise and cuisine can drastically set two populations apart
  - Differences in climate like heat can exert a different physical toll
  - Data is from one state in one country and so the likelihood of diversity and accurately representing global characteristics is likely not effective (consider a middle-age white American versus young black Senegalese versus senior Korean)
  - Majority of data are from men, which can be dangerous for women who are underrepresented

#### What effect does age have on heart disease?

+ One of the strongest and most consistent risk factors
+ Biological and lifestyle-related changes increases risk of CAD
+ Arteries stiffen and lose elasticity which increases blood pressure and strain on the heart
+ Plaque-forming from too much cholesterol is a cumulative process
+ Electrical signals controlling the heart can slow down or become erratic
+ Immune system becomes less efficient at repairing damaged blood vessels thereby weakening them
+ Other comorbidities such as diabetes, hypertension, and obesity can form as one gets older
+ Risk of CAD increases steeply after 45 for men and 55 for women (though often underdiagnosed)

#### What effect does cholesterol have on heart disease?

+ Waxy, fat-like substance found in blood
+ Essential for building cells and hormones
+ One of the primary risk factors
+ Too much cholesterol forms plaque (atherosclerosis) on the artery walls, effectively narrowing them and reducing oxygen-rich blood flow to the heart
+ A ruptured plaque can trigger a clot which fully blocks the artery and leading to a heart attack (myocardial infarction)

#### What effect does sex have on heart disease?

+ Men at higher risk of developing heart disease earlier in life, women later often after menopause
+ Estrogen is protective; men have low amounts and women have higher amounts pre-menopause
+ Men have larger vessels than women

#### What effect does resting blood pressure achieved (trestbps) on heart disease?

+ Resting systolic blood pressure (mm Hg) easily collected at a clinic
+ Hypertension (higher resting blood pressure) is a major risk factor in developing CAD:
  - High pressure weakens and scars arterial walls
  - Plaque can more easily build up
  - Heart needs to pump faster to move blood which causes the muscle to thicken and become less efficient; compounded on age makes it even riskier
  - Correlates with other conditions such as obesity, diabeties, and high cholesterol which adds strain to the heart and coronary arteries
  - Values above 130--140 are generally considered elevated or hypertensive

#### What effect does maximum heart rate achieved (thalach) on heart disease?

+ Gathered using a stress test
+ Lower heart rates can indicate cardiac limitations from reduced oxygen delivery from narrowed arteries, medications, or underlying muscle dysfunction

#### What effect does fasting blood sugar (fbs) on heart disease?

+ Recorded blood sugar levels at least 8 hours after last meal
+ Reflects effectiveness of glucose regulation and signals prediabities or diabeties
+ Diabetes accelerates plaque buildup since high blood sugar dmages the endothelial lining of arteries
+ Limitations from dataset: since it is binary, we do not know the relative amounts of how elevated the numbers are (say +5 mg/dL or +28 mg/dL?)
