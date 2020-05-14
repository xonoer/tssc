*! version 1.0  15jun2001* Stata version June 15, 2001 by John Hendrickx <J.Hendrickx@mailbox.kun.nl>/*Transforms ISCO-88 (International Classification of Occupation)4-digit occupational codes intoan ISEI scale (International Socio-Economic Index)Source:Ganzeboom, Harry B.G.;Treiman, Donald J.,International Stratification and Mobility File: Conversion Tools.Utrecht: Department of Sociologie,http://www.fss.uu.nl/soc/hg/ismf.ISCO-88 Reference:ILO (International Labour Office). (1990).International standard classification of occupations : ISCO-88.Geneva: International Labour Office.ISEI Reference:Ganzeboom, H.B.G. De Graaf, P.M. & D.J. Treiman. (1992)."A Standard International Socio-Economic Index of Occupational Status"Social Science Research 21: 1-56.*/program define iskoisei	version 7	syntax newvarname, isko(varname numeric)	/* original SPSS comments:	** Recode of ISKO-88 into ISEI	** Date of last revision: Summer 1996	** Please cite use of our conversion tools as:	** "Ganzeboom, Harry B.G.;Treiman, Donald J.,	** International Stratification and Mobility	** File: Conversion Tools. Utrecht: Department of Sociology*	** http://www.fss.uu.nl/soc/hg/ismf." Date of last revision.	*/	quietly gen `varlist'=.	quietly replace `varlist'=55 if (`isko' == 1000)	quietly replace `varlist'=70 if (`isko' == 1100)	quietly replace `varlist'=77 if (`isko' == 1110)	quietly replace `varlist'=77 if (`isko' == 1120)	quietly replace `varlist'=66 if (`isko' == 1130)	quietly replace `varlist'=58 if (`isko' == 1140)	quietly replace `varlist'=58 if (`isko' == 1141)	quietly replace `varlist'=58 if (`isko' == 1142)	quietly replace `varlist'=58 if (`isko' == 1143)	quietly replace `varlist'=68 if (`isko' == 1200)	quietly replace `varlist'=70 if (`isko' == 1210)	quietly replace `varlist'=67 if (`isko' == 1220)	quietly replace `varlist'=67 if (`isko' == 1221)	quietly replace `varlist'=67 if (`isko' == 1222)	quietly replace `varlist'=67 if (`isko' == 1223)	quietly replace `varlist'=59 if (`isko' == 1224)	quietly replace `varlist'=59 if (`isko' == 1225)	quietly replace `varlist'=59 if (`isko' == 1226)	quietly replace `varlist'=87 if (`isko' == 1227)	quietly replace `varlist'=59 if (`isko' == 1228)	quietly replace `varlist'=67 if (`isko' == 1229)	quietly replace `varlist'=61 if (`isko' == 1230)	quietly replace `varlist'=69 if (`isko' == 1231)	quietly replace `varlist'=69 if (`isko' == 1232)	quietly replace `varlist'=56 if (`isko' == 1233)	quietly replace `varlist'=69 if (`isko' == 1234)	quietly replace `varlist'=69 if (`isko' == 1235)	quietly replace `varlist'=69 if (`isko' == 1236)	quietly replace `varlist'=69 if (`isko' == 1237)	quietly replace `varlist'=69 if (`isko' == 1239)	quietly replace `varlist'=58 if (`isko' == 1240)	quietly replace `varlist'=64 if (`isko' == 1250)	quietly replace `varlist'=70 if (`isko' == 1251)	quietly replace `varlist'=60 if (`isko' == 1252)	quietly replace `varlist'=51 if (`isko' == 1300)	quietly replace `varlist'=51 if (`isko' == 1310)	quietly replace `varlist'=43 if (`isko' == 1311)	quietly replace `varlist'=56 if (`isko' == 1312)	quietly replace `varlist'=51 if (`isko' == 1313)	quietly replace `varlist'=49 if (`isko' == 1314)	quietly replace `varlist'=44 if (`isko' == 1315)	quietly replace `varlist'=51 if (`isko' == 1316)	quietly replace `varlist'=51 if (`isko' == 1317)	quietly replace `varlist'=51 if (`isko' == 1318)	quietly replace `varlist'=51 if (`isko' == 1319)	quietly replace `varlist'=70 if (`isko' == 2000)	quietly replace `varlist'=69 if (`isko' == 2100)	quietly replace `varlist'=74 if (`isko' == 2110)	quietly replace `varlist'=74 if (`isko' == 2111)	quietly replace `varlist'=74 if (`isko' == 2112)	quietly replace `varlist'=74 if (`isko' == 2113)	quietly replace `varlist'=74 if (`isko' == 2114)	quietly replace `varlist'=71 if (`isko' == 2120)	quietly replace `varlist'=71 if (`isko' == 2121)	quietly replace `varlist'=71 if (`isko' == 2122)	quietly replace `varlist'=71 if (`isko' == 2130)	quietly replace `varlist'=71 if (`isko' == 2131)	quietly replace `varlist'=71 if (`isko' == 2132)	quietly replace `varlist'=71 if (`isko' == 2139)	quietly replace `varlist'=73 if (`isko' == 2140)	quietly replace `varlist'=69 if (`isko' == 2141)	quietly replace `varlist'=69 if (`isko' == 2142)	quietly replace `varlist'=68 if (`isko' == 2143)	quietly replace `varlist'=68 if (`isko' == 2144)	quietly replace `varlist'=67 if (`isko' == 2145)	quietly replace `varlist'=71 if (`isko' == 2146)	quietly replace `varlist'=67 if (`isko' == 2147)	quietly replace `varlist'=56 if (`isko' == 2148)	quietly replace `varlist'=69 if (`isko' == 2149)	quietly replace `varlist'=80 if (`isko' == 2200)	quietly replace `varlist'=78 if (`isko' == 2210)	quietly replace `varlist'=77 if (`isko' == 2211)	quietly replace `varlist'=77 if (`isko' == 2212)	quietly replace `varlist'=79 if (`isko' == 2213)	quietly replace `varlist'=85 if (`isko' == 2220)	quietly replace `varlist'=88 if (`isko' == 2221)	quietly replace `varlist'=85 if (`isko' == 2222)	quietly replace `varlist'=83 if (`isko' == 2223)	quietly replace `varlist'=74 if (`isko' == 2224)	quietly replace `varlist'=85 if (`isko' == 2229)	quietly replace `varlist'=43 if (`isko' == 2230)	quietly replace `varlist'=69 if (`isko' == 2300)	quietly replace `varlist'=77 if (`isko' == 2310)	quietly replace `varlist'=69 if (`isko' == 2320)	quietly replace `varlist'=70 if (`isko' == 2321)	quietly replace `varlist'=66 if (`isko' == 2322)	quietly replace `varlist'=66 if (`isko' == 2330)	quietly replace `varlist'=66 if (`isko' == 2331)	quietly replace `varlist'=43 if (`isko' == 2332)	quietly replace `varlist'=66 if (`isko' == 2340)	quietly replace `varlist'=66 if (`isko' == 2350)	quietly replace `varlist'=70 if (`isko' == 2351)	quietly replace `varlist'=70 if (`isko' == 2352)	quietly replace `varlist'=65 if (`isko' == 2359)	quietly replace `varlist'=68 if (`isko' == 2400)	quietly replace `varlist'=69 if (`isko' == 2410)	quietly replace `varlist'=69 if (`isko' == 2411)	quietly replace `varlist'=69 if (`isko' == 2412)	quietly replace `varlist'=69 if (`isko' == 2419)	quietly replace `varlist'=85 if (`isko' == 2420)	quietly replace `varlist'=85 if (`isko' == 2421)	quietly replace `varlist'=90 if (`isko' == 2422)	quietly replace `varlist'=82 if (`isko' == 2429)	quietly replace `varlist'=65 if (`isko' == 2430)	quietly replace `varlist'=65 if (`isko' == 2431)	quietly replace `varlist'=65 if (`isko' == 2432)	quietly replace `varlist'=65 if (`isko' == 2440)	quietly replace `varlist'=78 if (`isko' == 2441)	quietly replace `varlist'=71 if (`isko' == 2442)	quietly replace `varlist'=71 if (`isko' == 2443)	quietly replace `varlist'=65 if (`isko' == 2444)	quietly replace `varlist'=71 if (`isko' == 2445)	quietly replace `varlist'=51 if (`isko' == 2446)	quietly replace `varlist'=61 if (`isko' == 2450)	quietly replace `varlist'=65 if (`isko' == 2451)	quietly replace `varlist'=54 if (`isko' == 2452)	quietly replace `varlist'=64 if (`isko' == 2453)	quietly replace `varlist'=64 if (`isko' == 2454)	quietly replace `varlist'=64 if (`isko' == 2455)	quietly replace `varlist'=53 if (`isko' == 2460)	quietly replace `varlist'=54 if (`isko' == 3000)	quietly replace `varlist'=50 if (`isko' == 3100)	quietly replace `varlist'=49 if (`isko' == 3110)	quietly replace `varlist'=45 if (`isko' == 3111)	quietly replace `varlist'=45 if (`isko' == 3112)	quietly replace `varlist'=46 if (`isko' == 3113)	quietly replace `varlist'=46 if (`isko' == 3114)	quietly replace `varlist'=54 if (`isko' == 3115)	quietly replace `varlist'=54 if (`isko' == 3116)	quietly replace `varlist'=54 if (`isko' == 3117)	quietly replace `varlist'=51 if (`isko' == 3118)	quietly replace `varlist'=53 if (`isko' == 3119)	quietly replace `varlist'=52 if (`isko' == 3120)	quietly replace `varlist'=52 if (`isko' == 3121)	quietly replace `varlist'=52 if (`isko' == 3122)	quietly replace `varlist'=52 if (`isko' == 3123)	quietly replace `varlist'=52 if (`isko' == 3130)	quietly replace `varlist'=48 if (`isko' == 3131)	quietly replace `varlist'=57 if (`isko' == 3132)	quietly replace `varlist'=57 if (`isko' == 3133)	quietly replace `varlist'=52 if (`isko' == 3139)	quietly replace `varlist'=57 if (`isko' == 3140)	quietly replace `varlist'=52 if (`isko' == 3141)	quietly replace `varlist'=52 if (`isko' == 3142)	quietly replace `varlist'=69 if (`isko' == 3143)	quietly replace `varlist'=69 if (`isko' == 3144)	quietly replace `varlist'=50 if (`isko' == 3145)	quietly replace `varlist'=50 if (`isko' == 3150)	quietly replace `varlist'=50 if (`isko' == 3151)	quietly replace `varlist'=50 if (`isko' == 3152)	quietly replace `varlist'=48 if (`isko' == 3200)	quietly replace `varlist'=50 if (`isko' == 3210)	quietly replace `varlist'=50 if (`isko' == 3211)	quietly replace `varlist'=50 if (`isko' == 3212)	quietly replace `varlist'=50 if (`isko' == 3213)	quietly replace `varlist'=55 if (`isko' == 3220)	quietly replace `varlist'=51 if (`isko' == 3221)	quietly replace `varlist'=51 if (`isko' == 3222)	quietly replace `varlist'=51 if (`isko' == 3223)	quietly replace `varlist'=60 if (`isko' == 3224)	quietly replace `varlist'=51 if (`isko' == 3225)	quietly replace `varlist'=60 if (`isko' == 3226)	quietly replace `varlist'=51 if (`isko' == 3227)	quietly replace `varlist'=51 if (`isko' == 3228)	quietly replace `varlist'=51 if (`isko' == 3229)	quietly replace `varlist'=38 if (`isko' == 3230)	quietly replace `varlist'=38 if (`isko' == 3231)	quietly replace `varlist'=38 if (`isko' == 3232)	quietly replace `varlist'=49 if (`isko' == 3240)	quietly replace `varlist'=51 if (`isko' == 3241)	quietly replace `varlist'=38 if (`isko' == 3242)	quietly replace `varlist'=38 if (`isko' == 3300)	quietly replace `varlist'=38 if (`isko' == 3310)	quietly replace `varlist'=38 if (`isko' == 3320)	quietly replace `varlist'=38 if (`isko' == 3330)	quietly replace `varlist'=38 if (`isko' == 3340)	quietly replace `varlist'=55 if (`isko' == 3400)	quietly replace `varlist'=55 if (`isko' == 3410)	quietly replace `varlist'=61 if (`isko' == 3411)	quietly replace `varlist'=54 if (`isko' == 3412)	quietly replace `varlist'=59 if (`isko' == 3413)	quietly replace `varlist'=56 if (`isko' == 3414)	quietly replace `varlist'=56 if (`isko' == 3415)	quietly replace `varlist'=50 if (`isko' == 3416)	quietly replace `varlist'=56 if (`isko' == 3417)	quietly replace `varlist'=55 if (`isko' == 3419)	quietly replace `varlist'=55 if (`isko' == 3420)	quietly replace `varlist'=55 if (`isko' == 3421)	quietly replace `varlist'=55 if (`isko' == 3422)	quietly replace `varlist'=55 if (`isko' == 3423)	quietly replace `varlist'=55 if (`isko' == 3429)	quietly replace `varlist'=54 if (`isko' == 3430)	quietly replace `varlist'=54 if (`isko' == 3431)	quietly replace `varlist'=59 if (`isko' == 3432)	quietly replace `varlist'=51 if (`isko' == 3433)	quietly replace `varlist'=61 if (`isko' == 3434)	quietly replace `varlist'=54 if (`isko' == 3439)	quietly replace `varlist'=56 if (`isko' == 3440)	quietly replace `varlist'=56 if (`isko' == 3441)	quietly replace `varlist'=57 if (`isko' == 3442)	quietly replace `varlist'=56 if (`isko' == 3443)	quietly replace `varlist'=46 if (`isko' == 3444)	quietly replace `varlist'=56 if (`isko' == 3449)	quietly replace `varlist'=56 if (`isko' == 3450)	quietly replace `varlist'=55 if (`isko' == 3451)	quietly replace `varlist'=56 if (`isko' == 3452)	quietly replace `varlist'=43 if (`isko' == 3460)	quietly replace `varlist'=52 if (`isko' == 3470)	quietly replace `varlist'=53 if (`isko' == 3471)	quietly replace `varlist'=64 if (`isko' == 3472)	quietly replace `varlist'=50 if (`isko' == 3473)	quietly replace `varlist'=50 if (`isko' == 3474)	quietly replace `varlist'=54 if (`isko' == 3475)	quietly replace `varlist'=38 if (`isko' == 3480)	quietly replace `varlist'=45 if (`isko' == 4000)	quietly replace `varlist'=45 if (`isko' == 4100)	quietly replace `varlist'=51 if (`isko' == 4110)	quietly replace `varlist'=51 if (`isko' == 4111)	quietly replace `varlist'=50 if (`isko' == 4112)	quietly replace `varlist'=50 if (`isko' == 4113)	quietly replace `varlist'=51 if (`isko' == 4114)	quietly replace `varlist'=53 if (`isko' == 4115)	quietly replace `varlist'=51 if (`isko' == 4120)	quietly replace `varlist'=51 if (`isko' == 4121)	quietly replace `varlist'=51 if (`isko' == 4122)	quietly replace `varlist'=36 if (`isko' == 4130)	quietly replace `varlist'=32 if (`isko' == 4131)	quietly replace `varlist'=43 if (`isko' == 4132)	quietly replace `varlist'=45 if (`isko' == 4133)	quietly replace `varlist'=39 if (`isko' == 4140)	quietly replace `varlist'=39 if (`isko' == 4141)	quietly replace `varlist'=39 if (`isko' == 4142)	quietly replace `varlist'=39 if (`isko' == 4143)	quietly replace `varlist'=39 if (`isko' == 4144)	quietly replace `varlist'=39 if (`isko' == 4190)	quietly replace `varlist'=49 if (`isko' == 4200)	quietly replace `varlist'=48 if (`isko' == 4210)	quietly replace `varlist'=53 if (`isko' == 4211)	quietly replace `varlist'=46 if (`isko' == 4212)	quietly replace `varlist'=40 if (`isko' == 4213)	quietly replace `varlist'=40 if (`isko' == 4214)	quietly replace `varlist'=40 if (`isko' == 4215)	quietly replace `varlist'=52 if (`isko' == 4220)	quietly replace `varlist'=52 if (`isko' == 4221)	quietly replace `varlist'=52 if (`isko' == 4222)	quietly replace `varlist'=52 if (`isko' == 4223)	quietly replace `varlist'=40 if (`isko' == 5000)	quietly replace `varlist'=38 if (`isko' == 5100)	quietly replace `varlist'=34 if (`isko' == 5110)	quietly replace `varlist'=34 if (`isko' == 5111)	quietly replace `varlist'=34 if (`isko' == 5112)	quietly replace `varlist'=34 if (`isko' == 5113)	quietly replace `varlist'=32 if (`isko' == 5120)	quietly replace `varlist'=30 if (`isko' == 5121)	quietly replace `varlist'=30 if (`isko' == 5122)	quietly replace `varlist'=34 if (`isko' == 5123)	quietly replace `varlist'=25 if (`isko' == 5130)	quietly replace `varlist'=25 if (`isko' == 5131)	quietly replace `varlist'=25 if (`isko' == 5132)	quietly replace `varlist'=25 if (`isko' == 5133)	quietly replace `varlist'=25 if (`isko' == 5139)	quietly replace `varlist'=30 if (`isko' == 5140)	quietly replace `varlist'=29 if (`isko' == 5141)	quietly replace `varlist'=19 if (`isko' == 5142)	quietly replace `varlist'=54 if (`isko' == 5143)	quietly replace `varlist'=19 if (`isko' == 5149)	quietly replace `varlist'=43 if (`isko' == 5150)	quietly replace `varlist'=43 if (`isko' == 5151)	quietly replace `varlist'=43 if (`isko' == 5152)	quietly replace `varlist'=47 if (`isko' == 5160)	quietly replace `varlist'=42 if (`isko' == 5161)	quietly replace `varlist'=50 if (`isko' == 5162)	quietly replace `varlist'=40 if (`isko' == 5163)	quietly replace `varlist'=40 if (`isko' == 5164)	quietly replace `varlist'=40 if (`isko' == 5169)	quietly replace `varlist'=43 if (`isko' == 5200)	quietly replace `varlist'=43 if (`isko' == 5210)	quietly replace `varlist'=43 if (`isko' == 5220)	quietly replace `varlist'=37 if (`isko' == 5230)	quietly replace `varlist'=23 if (`isko' == 6000)	quietly replace `varlist'=23 if (`isko' == 6100)	quietly replace `varlist'=23 if (`isko' == 6110)	quietly replace `varlist'=23 if (`isko' == 6111)	quietly replace `varlist'=23 if (`isko' == 6112)	quietly replace `varlist'=23 if (`isko' == 6113)	quietly replace `varlist'=23 if (`isko' == 6114)	quietly replace `varlist'=23 if (`isko' == 6120)	quietly replace `varlist'=23 if (`isko' == 6121)	quietly replace `varlist'=23 if (`isko' == 6122)	quietly replace `varlist'=23 if (`isko' == 6123)	quietly replace `varlist'=23 if (`isko' == 6124)	quietly replace `varlist'=23 if (`isko' == 6129)	quietly replace `varlist'=23 if (`isko' == 6130)	quietly replace `varlist'=23 if (`isko' == 6131)	quietly replace `varlist'=27 if (`isko' == 6132)	quietly replace `varlist'=28 if (`isko' == 6133)	quietly replace `varlist'=28 if (`isko' == 6134)	quietly replace `varlist'=22 if (`isko' == 6140)	quietly replace `varlist'=22 if (`isko' == 6141)	quietly replace `varlist'=22 if (`isko' == 6142)	quietly replace `varlist'=28 if (`isko' == 6150)	quietly replace `varlist'=28 if (`isko' == 6151)	quietly replace `varlist'=28 if (`isko' == 6152)	quietly replace `varlist'=28 if (`isko' == 6153)	quietly replace `varlist'=28 if (`isko' == 6154)	quietly replace `varlist'=16 if (`isko' == 6200)	quietly replace `varlist'=16 if (`isko' == 6210)	quietly replace `varlist'=34 if (`isko' == 7000)	quietly replace `varlist'=31 if (`isko' == 7100)	quietly replace `varlist'=30 if (`isko' == 7110)	quietly replace `varlist'=30 if (`isko' == 7111)	quietly replace `varlist'=30 if (`isko' == 7112)	quietly replace `varlist'=27 if (`isko' == 7113)	quietly replace `varlist'=30 if (`isko' == 7120)	quietly replace `varlist'=29 if (`isko' == 7121)	quietly replace `varlist'=29 if (`isko' == 7122)	quietly replace `varlist'=26 if (`isko' == 7123)	quietly replace `varlist'=29 if (`isko' == 7124)	quietly replace `varlist'=30 if (`isko' == 7129)	quietly replace `varlist'=34 if (`isko' == 7130)	quietly replace `varlist'=19 if (`isko' == 7131)	quietly replace `varlist'=30 if (`isko' == 7132)	quietly replace `varlist'=31 if (`isko' == 7133)	quietly replace `varlist'=34 if (`isko' == 7134)	quietly replace `varlist'=26 if (`isko' == 7135)	quietly replace `varlist'=33 if (`isko' == 7136)	quietly replace `varlist'=37 if (`isko' == 7137)	quietly replace `varlist'=29 if (`isko' == 7140)	quietly replace `varlist'=29 if (`isko' == 7141)	quietly replace `varlist'=32 if (`isko' == 7142)	quietly replace `varlist'=29 if (`isko' == 7143)	quietly replace `varlist'=34 if (`isko' == 7200)	quietly replace `varlist'=31 if (`isko' == 7210)	quietly replace `varlist'=29 if (`isko' == 7211)	quietly replace `varlist'=30 if (`isko' == 7212)	quietly replace `varlist'=33 if (`isko' == 7213)	quietly replace `varlist'=30 if (`isko' == 7214)	quietly replace `varlist'=30 if (`isko' == 7215)	quietly replace `varlist'=30 if (`isko' == 7216)	quietly replace `varlist'=35 if (`isko' == 7220)	quietly replace `varlist'=33 if (`isko' == 7221)	quietly replace `varlist'=40 if (`isko' == 7222)	quietly replace `varlist'=34 if (`isko' == 7223)	quietly replace `varlist'=24 if (`isko' == 7224)	quietly replace `varlist'=34 if (`isko' == 7230)	quietly replace `varlist'=34 if (`isko' == 7231)	quietly replace `varlist'=42 if (`isko' == 7232)	quietly replace `varlist'=33 if (`isko' == 7233)	quietly replace `varlist'=23 if (`isko' == 7234)	quietly replace `varlist'=40 if (`isko' == 7240)	quietly replace `varlist'=40 if (`isko' == 7241)	quietly replace `varlist'=39 if (`isko' == 7242)	quietly replace `varlist'=41 if (`isko' == 7243)	quietly replace `varlist'=40 if (`isko' == 7244)	quietly replace `varlist'=38 if (`isko' == 7245)	quietly replace `varlist'=34 if (`isko' == 7300)	quietly replace `varlist'=38 if (`isko' == 7310)	quietly replace `varlist'=38 if (`isko' == 7311)	quietly replace `varlist'=38 if (`isko' == 7312)	quietly replace `varlist'=38 if (`isko' == 7313)	quietly replace `varlist'=28 if (`isko' == 7320)	quietly replace `varlist'=27 if (`isko' == 7321)	quietly replace `varlist'=29 if (`isko' == 7322)	quietly replace `varlist'=29 if (`isko' == 7323)	quietly replace `varlist'=29 if (`isko' == 7324)	quietly replace `varlist'=29 if (`isko' == 7330)	quietly replace `varlist'=29 if (`isko' == 7331)	quietly replace `varlist'=29 if (`isko' == 7332)	quietly replace `varlist'=40 if (`isko' == 7340)	quietly replace `varlist'=40 if (`isko' == 7341)	quietly replace `varlist'=40 if (`isko' == 7342)	quietly replace `varlist'=42 if (`isko' == 7343)	quietly replace `varlist'=40 if (`isko' == 7344)	quietly replace `varlist'=37 if (`isko' == 7345)	quietly replace `varlist'=38 if (`isko' == 7346)	quietly replace `varlist'=33 if (`isko' == 7400)	quietly replace `varlist'=30 if (`isko' == 7410)	quietly replace `varlist'=30 if (`isko' == 7411)	quietly replace `varlist'=31 if (`isko' == 7412)	quietly replace `varlist'=30 if (`isko' == 7413)	quietly replace `varlist'=30 if (`isko' == 7414)	quietly replace `varlist'=30 if (`isko' == 7415)	quietly replace `varlist'=30 if (`isko' == 7416)	quietly replace `varlist'=33 if (`isko' == 7420)	quietly replace `varlist'=33 if (`isko' == 7421)	quietly replace `varlist'=33 if (`isko' == 7422)	quietly replace `varlist'=33 if (`isko' == 7423)	quietly replace `varlist'=33 if (`isko' == 7424)	quietly replace `varlist'=36 if (`isko' == 7430)	quietly replace `varlist'=29 if (`isko' == 7431)	quietly replace `varlist'=29 if (`isko' == 7432)	quietly replace `varlist'=45 if (`isko' == 7433)	quietly replace `varlist'=36 if (`isko' == 7434)	quietly replace `varlist'=36 if (`isko' == 7435)	quietly replace `varlist'=33 if (`isko' == 7436)	quietly replace `varlist'=28 if (`isko' == 7437)	quietly replace `varlist'=31 if (`isko' == 7440)	quietly replace `varlist'=31 if (`isko' == 7441)	quietly replace `varlist'=31 if (`isko' == 7442)	quietly replace `varlist'=42 if (`isko' == 7500)	quietly replace `varlist'=42 if (`isko' == 7510)	quietly replace `varlist'=39 if (`isko' == 7520)	quietly replace `varlist'=26 if (`isko' == 7530)	quietly replace `varlist'=31 if (`isko' == 8000)	quietly replace `varlist'=30 if (`isko' == 8100)	quietly replace `varlist'=35 if (`isko' == 8110)	quietly replace `varlist'=35 if (`isko' == 8111)	quietly replace `varlist'=35 if (`isko' == 8112)	quietly replace `varlist'=35 if (`isko' == 8113)	quietly replace `varlist'=30 if (`isko' == 8120)	quietly replace `varlist'=31 if (`isko' == 8121)	quietly replace `varlist'=30 if (`isko' == 8122)	quietly replace `varlist'=28 if (`isko' == 8123)	quietly replace `varlist'=30 if (`isko' == 8124)	quietly replace `varlist'=22 if (`isko' == 8130)	quietly replace `varlist'=22 if (`isko' == 8131)	quietly replace `varlist'=22 if (`isko' == 8139)	quietly replace `varlist'=27 if (`isko' == 8140)	quietly replace `varlist'=27 if (`isko' == 8141)	quietly replace `varlist'=27 if (`isko' == 8142)	quietly replace `varlist'=27 if (`isko' == 8143)	quietly replace `varlist'=35 if (`isko' == 8150)	quietly replace `varlist'=35 if (`isko' == 8151)	quietly replace `varlist'=35 if (`isko' == 8152)	quietly replace `varlist'=35 if (`isko' == 8153)	quietly replace `varlist'=35 if (`isko' == 8154)	quietly replace `varlist'=35 if (`isko' == 8155)	quietly replace `varlist'=35 if (`isko' == 8159)	quietly replace `varlist'=32 if (`isko' == 8160)	quietly replace `varlist'=33 if (`isko' == 8161)	quietly replace `varlist'=27 if (`isko' == 8162)	quietly replace `varlist'=33 if (`isko' == 8163)	quietly replace `varlist'=26 if (`isko' == 8170)	quietly replace `varlist'=26 if (`isko' == 8171)	quietly replace `varlist'=26 if (`isko' == 8172)	quietly replace `varlist'=32 if (`isko' == 8200)	quietly replace `varlist'=36 if (`isko' == 8210)	quietly replace `varlist'=36 if (`isko' == 8211)	quietly replace `varlist'=30 if (`isko' == 8212)	quietly replace `varlist'=30 if (`isko' == 8220)	quietly replace `varlist'=30 if (`isko' == 8221)	quietly replace `varlist'=30 if (`isko' == 8222)	quietly replace `varlist'=30 if (`isko' == 8223)	quietly replace `varlist'=30 if (`isko' == 8224)	quietly replace `varlist'=30 if (`isko' == 8229)	quietly replace `varlist'=30 if (`isko' == 8230)	quietly replace `varlist'=30 if (`isko' == 8231)	quietly replace `varlist'=30 if (`isko' == 8232)	quietly replace `varlist'=29 if (`isko' == 8240)	quietly replace `varlist'=38 if (`isko' == 8250)	quietly replace `varlist'=38 if (`isko' == 8251)	quietly replace `varlist'=38 if (`isko' == 8252)	quietly replace `varlist'=38 if (`isko' == 8253)	quietly replace `varlist'=30 if (`isko' == 8260)	quietly replace `varlist'=29 if (`isko' == 8261)	quietly replace `varlist'=29 if (`isko' == 8262)	quietly replace `varlist'=32 if (`isko' == 8263)	quietly replace `varlist'=24 if (`isko' == 8264)	quietly replace `varlist'=32 if (`isko' == 8265)	quietly replace `varlist'=32 if (`isko' == 8266)	quietly replace `varlist'=32 if (`isko' == 8269)	quietly replace `varlist'=29 if (`isko' == 8270)	quietly replace `varlist'=29 if (`isko' == 8271)	quietly replace `varlist'=29 if (`isko' == 8272)	quietly replace `varlist'=29 if (`isko' == 8273)	quietly replace `varlist'=29 if (`isko' == 8274)	quietly replace `varlist'=29 if (`isko' == 8275)	quietly replace `varlist'=29 if (`isko' == 8276)	quietly replace `varlist'=29 if (`isko' == 8277)	quietly replace `varlist'=29 if (`isko' == 8278)	quietly replace `varlist'=29 if (`isko' == 8279)	quietly replace `varlist'=31 if (`isko' == 8280)	quietly replace `varlist'=30 if (`isko' == 8281)	quietly replace `varlist'=34 if (`isko' == 8282)	quietly replace `varlist'=34 if (`isko' == 8283)	quietly replace `varlist'=30 if (`isko' == 8284)	quietly replace `varlist'=30 if (`isko' == 8285)	quietly replace `varlist'=30 if (`isko' == 8286)	quietly replace `varlist'=26 if (`isko' == 8290)	quietly replace `varlist'=32 if (`isko' == 8300)	quietly replace `varlist'=36 if (`isko' == 8310)	quietly replace `varlist'=41 if (`isko' == 8311)	quietly replace `varlist'=32 if (`isko' == 8312)	quietly replace `varlist'=34 if (`isko' == 8320)	quietly replace `varlist'=30 if (`isko' == 8321)	quietly replace `varlist'=30 if (`isko' == 8322)	quietly replace `varlist'=30 if (`isko' == 8323)	quietly replace `varlist'=34 if (`isko' == 8324)	quietly replace `varlist'=26 if (`isko' == 8330)	quietly replace `varlist'=26 if (`isko' == 8331)	quietly replace `varlist'=26 if (`isko' == 8332)	quietly replace `varlist'=28 if (`isko' == 8333)	quietly replace `varlist'=28 if (`isko' == 8334)	quietly replace `varlist'=32 if (`isko' == 8340)	quietly replace `varlist'=24 if (`isko' == 8400)	quietly replace `varlist'=20 if (`isko' == 9000)	quietly replace `varlist'=25 if (`isko' == 9100)	quietly replace `varlist'=29 if (`isko' == 9110)	quietly replace `varlist'=29 if (`isko' == 9111)	quietly replace `varlist'=28 if (`isko' == 9112)	quietly replace `varlist'=29 if (`isko' == 9113)	quietly replace `varlist'=28 if (`isko' == 9120)	quietly replace `varlist'=16 if (`isko' == 9130)	quietly replace `varlist'=16 if (`isko' == 9131)	quietly replace `varlist'=16 if (`isko' == 9132)	quietly replace `varlist'=16 if (`isko' == 9133)	quietly replace `varlist'=23 if (`isko' == 9140)	quietly replace `varlist'=23 if (`isko' == 9141)	quietly replace `varlist'=23 if (`isko' == 9142)	quietly replace `varlist'=27 if (`isko' == 9150)	quietly replace `varlist'=25 if (`isko' == 9151)	quietly replace `varlist'=27 if (`isko' == 9152)	quietly replace `varlist'=27 if (`isko' == 9153)	quietly replace `varlist'=23 if (`isko' == 9160)	quietly replace `varlist'=23 if (`isko' == 9161)	quietly replace `varlist'=23 if (`isko' == 9162)	quietly replace `varlist'=16 if (`isko' == 9200)	quietly replace `varlist'=16 if (`isko' == 9210)	quietly replace `varlist'=16 if (`isko' == 9211)	quietly replace `varlist'=16 if (`isko' == 9212)	quietly replace `varlist'=16 if (`isko' == 9213)	quietly replace `varlist'=23 if (`isko' == 9300)	quietly replace `varlist'=21 if (`isko' == 9310)	quietly replace `varlist'=21 if (`isko' == 9311)	quietly replace `varlist'=21 if (`isko' == 9312)	quietly replace `varlist'=21 if (`isko' == 9313)	quietly replace `varlist'=20 if (`isko' == 9320)	quietly replace `varlist'=20 if (`isko' == 9321)	quietly replace `varlist'=24 if (`isko' == 9322)	quietly replace `varlist'=29 if (`isko' == 9330)	quietly replace `varlist'=22 if (`isko' == 9331)	quietly replace `varlist'=22 if (`isko' == 9332)	quietly replace `varlist'=30 if (`isko' == 9333)endB