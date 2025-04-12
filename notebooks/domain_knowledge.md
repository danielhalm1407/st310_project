# Healthcare Domain Knowledge

#### Why is the heart important and how is heart disease defined?

The human heart persistently supplies blood throughout the body through the circulatory system so our organs can operate. However, the heart is still susceptible to injuries, which can be intensely damaging or even life-threatening. Excess fluid in body tissues, impaired thinking, and sudden weight changes are some indicators of a failing heart.[1] Understanding what causes and further exacerbates heart problems is crucial for patient health.

There are several types of heart disease including strokes and transient ischaemic attacks, peripheral arterial disease, and cortic diseases; however, this study focuses on coronary artery disease (CAD), which is caused when the heart is strained by reduced or blocked oxygen-rich blood flow.[2] A buildup of plaque (atherosclerosis) caused primarily by cholesterol and fats shrink the arteries over several years, eventually culminating in CAD through chest pain (anginas), heart attacks, and heart failure.[3]

#### Where is our dataset from and what can we understand from it? What are its limitations?

A 1988 heart disease study from the University of California Irvine created a discriminant function model for predicting angiographic coronary disease in patients and compared the results to a Bayesian algorithm.[4] It is common for doctors and researchers to get an X-ray scan of a patient’s heart to detect the presence or absence of angiographic coronary disease by checking if the blood vessels are sufficiently open and unblocked.[5] The result of an angiography is either heart disease is present or absent. This study collected patient results from angiographies and relevant health diagnostics to create their predictor model.[6]

The original study by Detrano et al. (1989) aggregated patient data from the Cleveland Clinic (303 patients); Budapest, Hungary (425 patients); Zurich and Basel, Switzerland (143 patients); and the Veterans Administration Long Beach, California (200 patients). We were only able to make use to the Cleveland Clinic subset which had 1,025 observations.

Although these data were collected from a large study and helped researchers understand more in understanding coronary artery disease, there are some important limitations in the data to consider. These data were published in 1988 and, at the time of this report, important medical, political, social, and environmental advancements have been made in the past 37 years. *[advancements such as what? environmental changes such as more pollution, newer medical tests and measurements related to heart health, new policies to encourage healthier ingredients and foods, etc. -- find reputable sources to support claims.]*

Additionally, our dataset has a lot more men (713) then women (312) which could suggest that models fitted on these data will skew to accommodate male measurements better. This can be dangerous since women, as well as other vulnerable communities, are often overlooked in the medical community compared to white men.[10][11]

Finally, these data were collected in one hospital in one state in one country, so the data likely represents that particular area well but maybe not the global population. A patient from humid continental Ohio is likely very different from a patient in the Mediterreanean climate of Algeria. If we strive to use our models to help patients around the globe, we need a more diverse dataset ranging across cultures, climates, nations, and peoples.

#### How is heart disease diagnosed in practice?

Doctors diagnose heart disease by a mix of patient-reported symptoms, common physical examinations, and different diagnostic tests based on their findings. Electrocardiograms (EKGs) are a non-invasive procedure that measure the heart muscle's electrical activity and is common for identifying irregular heartbeats (arrhythmias) and poor blood flow (ischemia).[7] Physicians usually have patients do two EKG tests while they are resting and while exercising (called a stress test) to see how the heart performs under exertion to properly identify if they have heart disease and its severity. Another common non-invasive diagnostic tool is an echocardiogram which uses high-frequency sound waves, an ultrasound, to scan the heart and nearby blood vessels in real time.[8] These "echos" help cardiologists get an overview of the structural health of a patient's heart which is vital when recovering from cardiovascular damage. The standard of care, however, is a coronary angiography where contrast dyes are injected through coronary arteries and X-rays identify blockages; unlike the aforementioned procedures, an angiography is invasive however provides more actionable value to the physians.[9] These procedures are quick enough that patients can return home on the same day with little impact to their normal routine. Features present in the UCI Heart Disease dataset such as `slope`, `cp`, and `thalach` are measurements as a result of these medical diagnostic tests, whereas other features like `sex`, `age`, and `cholesterol` are recorded from physical examinations. Doctors then take these measurements are use their extensive domain knowledge to conclude if a patient has coronary artery disease or not. Their conclusions are supported by test results and by comparing medical measurements, such as cholesterol, with what is medically accepted to be a "safe" or "healthy" amount in someone of a similar sex, age, and other morphometric characteristics.

#### Why is heart disease "bad" and why is it such a prevalent issue?

Coronary artery disease is the leading cause of death across both genders in the United States and the second leading cause of death (behind Alzheimer's/dementia) across both genders in the United Kingdom.[12][13] For context, 1 in 8 men and 1 in 14 women die from CAD for an average of one person dying every 8 minutes.[14] Since artery disease builds up over years it is a silent disease and the first symptoms are usually severe like chest pain or even a heart attack. Eventually CAD reduces a patient's quality of life because the strain on the heart limits their physical activity, causes fatigue, strong chest pain, and even long-term disability or hospitalization.[15]

Although this disease is dangerous current medicine is advance enough to make it preventable through medications, interventions, and lifestyle changes. Therefore, it is essential for physicians to find ways to accurately diagnose the right patients with heart disease before it becomes too severe. Unfortunately, like mentioned before, the vulnerable members of society (people of color, women, LGBTQ+) are often overlooked and therefore underdiagnosed and undertreated, adding to these large fatality figures. 

#### What is the significance of our models? What are we trying to do?

(in progress)

#### What does "interpretable" modeling mean in medicine?

(in progress)

#### What are the consequences of false positives or false negatives?

(in progress)

#### What are the ethical concerns around predicitive models for health?

(in progress)

#### What effect does {all the predictors} have on heart disease?

(have rough notes finished, working on converting to paragraph form with citations now)

[1]: https://www.heart.org/en/health-topics/heart-failure/warning-signs-of-heart-failure
[2]: https://www.nhs.uk/conditions/cardiovascular-disease/
[3]: https://www.mayoclinic.org/diseases-conditions/coronary-artery-disease/symptoms-causes/syc-20350613
[4]: https://doi.org/10.1016/0002-9149(89)90524-9
[5]: https://www.mayoclinic.org/tests-procedures/coronary-angiogram/about/pac-20384904
[6]: https://doi.org/10.1016/0002-9149(89)90524-9
[7]: https://www.bhf.org.uk/informationsupport/heart-matters-magazine/medical/tests/electrocardiogram-ecg
[8]: https://www.nhs.uk/conditions/echocardiogram/
[9]: https://www.nhs.uk/conditions/coronary-angiography/
[10]: https://www.sciencedirect.com/science/article/abs/pii/S0147956395800204
[11]: https://my.clevelandclinic.org/health/articles/23051-ethnicity-and-heart-disease
[12]: https://www.bhf.org.uk/-/media/files/for-professionals/research/heart-statistics/bhf-cvd-statistics-uk-factsheet.pdf?rev=81a8015761aa4ced8bc39d7045202be5&hash=9D78ACBF5EB80FA8A9BE28C90BFBE171
[13]: https://www.cdc.gov/heart-disease/data-research/facts-stats/index.html
[14]: https://www.bhf.org.uk/-/media/files/for-professionals/research/heart-statistics/bhf-cvd-statistics-uk-factsheet.pdf?rev=81a8015761aa4ced8bc39d7045202be5&hash=9D78ACBF5EB80FA8A9BE28C90BFBE171
[15]: https://www.pennmedicine.org/for-patients-and-visitors/patient-information/conditions-treated-a-to-z/coronary-artery-disease
