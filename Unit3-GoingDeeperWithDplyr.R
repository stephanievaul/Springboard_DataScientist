
R version 3.3.1 (2016-06-21) -- "Bug in Your Hair"
Copyright (C) 2016 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

[Workspace loaded from ~/Springboard_DataScientist/.RData]

> load("~/Springboard_DataScientist/.RData")
> data() 
> library(dplyr)

Attaching package: ‘dplyr’

The following objects are masked from ‘package:stats’:
  
  filter, lag

The following objects are masked from ‘package:base’:
  
  intersect, setdiff, setequal, union

> library("nycflights13")
> flights
Source: local data frame [336,776 x 19]

year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
(int) (int) (int)    (int)          (int)     (dbl)    (int)          (int)
1   2013     1     1      517            515         2      830            819
2   2013     1     1      533            529         4      850            830
3   2013     1     1      542            540         2      923            850
4   2013     1     1      544            545        -1     1004           1022
5   2013     1     1      554            600        -6      812            837
6   2013     1     1      554            558        -4      740            728
7   2013     1     1      555            600        -5      913            854
8   2013     1     1      557            600        -3      709            723
9   2013     1     1      557            600        -3      838            846
10  2013     1     1      558            600        -2      753            745
..   ...   ...   ...      ...            ...       ...      ...            ...
Variables not shown: arr_delay (dbl), carrier (chr), flight (int), tailnum (chr),
origin (chr), dest (chr), air_time (dbl), distance (dbl), hour (dbl), minute
(dbl), time_hour (time)
> flights %>% select(carrier, flight)
Source: local data frame [336,776 x 2]

carrier flight
(chr)  (int)
1       UA   1545
2       UA   1714
3       AA   1141
4       B6    725
5       DL    461
6       UA   1696
7       B6    507
8       EV   5708
9       B6     79
10      AA    301
..     ...    ...
> flights  %>% select(-month, -day)
Source: local data frame [336,776 x 17]

year dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
(int)    (int)          (int)     (dbl)    (int)          (int)     (dbl)
1   2013      517            515         2      830            819        11
2   2013      533            529         4      850            830        20
3   2013      542            540         2      923            850        33
4   2013      544            545        -1     1004           1022       -18
5   2013      554            600        -6      812            837       -25
6   2013      554            558        -4      740            728        12
7   2013      555            600        -5      913            854        19
8   2013      557            600        -3      709            723       -14
9   2013      557            600        -3      838            846        -8
10  2013      558            600        -2      753            745         8
..   ...      ...            ...       ...      ...            ...       ...
Variables not shown: carrier (chr), flight (int), tailnum (chr), origin (chr),
dest (chr), air_time (dbl), distance (dbl), hour (dbl), minute (dbl), time_hour
(time)
> flights  %>% select(-(dep_time:arr_delay))
Source: local data frame [336,776 x 13]

year month   day carrier flight tailnum origin  dest air_time distance  hour
(int) (int) (int)   (chr)  (int)   (chr)  (chr) (chr)    (dbl)    (dbl) (dbl)
1   2013     1     1      UA   1545  N14228    EWR   IAH      227     1400     5
2   2013     1     1      UA   1714  N24211    LGA   IAH      227     1416     5
3   2013     1     1      AA   1141  N619AA    JFK   MIA      160     1089     5
4   2013     1     1      B6    725  N804JB    JFK   BQN      183     1576     5
5   2013     1     1      DL    461  N668DN    LGA   ATL      116      762     6
6   2013     1     1      UA   1696  N39463    EWR   ORD      150      719     5
7   2013     1     1      B6    507  N516JB    EWR   FLL      158     1065     6
8   2013     1     1      EV   5708  N829AS    LGA   IAD       53      229     6
9   2013     1     1      B6     79  N593JB    JFK   MCO      140      944     6
10  2013     1     1      AA    301  N3ALAA    LGA   ORD      138      733     6
..   ...   ...   ...     ...    ...     ...    ...   ...      ...      ...   ...
Variables not shown: minute (dbl), time_hour (time)
> flights  %>% select(-contains("time"))
Source: local data frame [336,776 x 13]

year month   day dep_delay arr_delay carrier flight tailnum origin  dest distance
(int) (int) (int)     (dbl)     (dbl)   (chr)  (int)   (chr)  (chr) (chr)    (dbl)
1   2013     1     1         2        11      UA   1545  N14228    EWR   IAH     1400
2   2013     1     1         4        20      UA   1714  N24211    LGA   IAH     1416
3   2013     1     1         2        33      AA   1141  N619AA    JFK   MIA     1089
4   2013     1     1        -1       -18      B6    725  N804JB    JFK   BQN     1576
5   2013     1     1        -6       -25      DL    461  N668DN    LGA   ATL      762
6   2013     1     1        -4        12      UA   1696  N39463    EWR   ORD      719
7   2013     1     1        -5        19      B6    507  N516JB    EWR   FLL     1065
8   2013     1     1        -3       -14      EV   5708  N829AS    LGA   IAD      229
9   2013     1     1        -3        -8      B6     79  N593JB    JFK   MCO      944
10  2013     1     1        -2         8      AA    301  N3ALAA    LGA   ORD      733
..   ...   ...   ...       ...       ...     ...    ...     ...    ...   ...      ...
Variables not shown: hour (dbl), minute (dbl)
> flights %>% filter(dep_time >= 600, dep_time <= 605)
Source: local data frame [2,460 x 19]

year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
(int) (int) (int)    (int)          (int)     (dbl)    (int)          (int)     (dbl)
1   2013     1     1      600            600         0      851            858        -7
2   2013     1     1      600            600         0      837            825        12
3   2013     1     1      601            600         1      844            850        -6
4   2013     1     1      602            610        -8      812            820        -8
5   2013     1     1      602            605        -3      821            805        16
6   2013     1     2      600            600         0      814            749        25
7   2013     1     2      600            605        -5      751            818       -27
8   2013     1     2      600            600         0      819            815         4
9   2013     1     2      600            600         0      846            846         0
10  2013     1     2      600            600         0      737            725        12
..   ...   ...   ...      ...            ...       ...      ...            ...       ...
Variables not shown: carrier (chr), flight (int), tailnum (chr), origin (chr), dest
(chr), air_time (dbl), distance (dbl), hour (dbl), minute (dbl), time_hour (time)
> flights %>% filter(dep_time >= 600 & dep_time <= 605)
Source: local data frame [2,460 x 19]

year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
(int) (int) (int)    (int)          (int)     (dbl)    (int)          (int)     (dbl)
1   2013     1     1      600            600         0      851            858        -7
2   2013     1     1      600            600         0      837            825        12
3   2013     1     1      601            600         1      844            850        -6
4   2013     1     1      602            610        -8      812            820        -8
5   2013     1     1      602            605        -3      821            805        16
6   2013     1     2      600            600         0      814            749        25
7   2013     1     2      600            605        -5      751            818       -27
8   2013     1     2      600            600         0      819            815         4
9   2013     1     2      600            600         0      846            846         0
10  2013     1     2      600            600         0      737            725        12
..   ...   ...   ...      ...            ...       ...      ...            ...       ...
Variables not shown: carrier (chr), flight (int), tailnum (chr), origin (chr), dest
(chr), air_time (dbl), distance (dbl), hour (dbl), minute (dbl), time_hour (time)
> 
  > 
  > 
  > 
  > 
  > flights %>% group_by(month, day) %>% slice(1:3)
Source: local data frame [1,095 x 19]
Groups: month, day [365]

year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
(int) (int) (int)    (int)          (int)     (dbl)    (int)          (int)     (dbl)
1   2013     1     1      517            515         2      830            819        11
2   2013     1     1      533            529         4      850            830        20
3   2013     1     1      542            540         2      923            850        33
4   2013     1     2       42           2359        43      518            442        36
5   2013     1     2      126           2250       156      233           2359       154
6   2013     1     2      458            500        -2      703            650        13
7   2013     1     3       32           2359        33      504            442        22
8   2013     1     3       50           2145       185      203           2311       172
9   2013     1     3      235           2359       156      700            437       143
10  2013     1     4       25           2359        26      505            442        23
..   ...   ...   ...      ...            ...       ...      ...            ...       ...
Variables not shown: carrier (chr), flight (int), tailnum (chr), origin (chr), dest
(chr), air_time (dbl), distance (dbl), hour (dbl), minute (dbl), time_hour (time)
> flights %>% group_by(month, day) %>% top_n(3, dep_delay)
Source: local data frame [1,108 x 19]
Groups: month, day [365]

year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
(int) (int) (int)    (int)          (int)     (dbl)    (int)          (int)     (dbl)
1   2013     1     1      848           1835       853     1001           1950       851
2   2013     1     1     1815           1325       290     2120           1542       338
3   2013     1     1     2343           1724       379      314           1938       456
4   2013     1     2     1412            838       334     1710           1147       323
5   2013     1     2     1607           1030       337     2003           1355       368
6   2013     1     2     2131           1512       379     2340           1741       359
7   2013     1     3     2008           1540       268     2339           1909       270
8   2013     1     3     2012           1600       252     2314           1857       257
9   2013     1     3     2056           1605       291     2239           1754       285
10  2013     1     4     2058           1730       208        2           2110       172
..   ...   ...   ...      ...            ...       ...      ...            ...       ...
Variables not shown: carrier (chr), flight (int), tailnum (chr), origin (chr), dest
(chr), air_time (dbl), distance (dbl), hour (dbl), minute (dbl), time_hour (time)
> flights %>% group_by(month, day) %>% top_n(3, desc(dep_delay)
+ flights %>% group_by(month, day) %>% top_n(3, desc(dep_delay))
Error: unexpected symbol in:
"flights %>% group_by(month, day) %>% top_n(3, desc(dep_delay)
flights"
> flights %>% group_by(month, day) %>% top_n(3, dep_delay) %>% arrange(desc(dep_delay))
Source: local data frame [1,108 x 19]
Groups: month, day [365]

year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
(int) (int) (int)    (int)          (int)     (dbl)    (int)          (int)     (dbl)
1   2013     1     1      848           1835       853     1001           1950       851
2   2013     1     1     2343           1724       379      314           1938       456
3   2013     1     1     1815           1325       290     2120           1542       338
4   2013     1     2     2131           1512       379     2340           1741       359
5   2013     1     2     1607           1030       337     2003           1355       368
6   2013     1     2     1412            838       334     1710           1147       323
7   2013     1     3     2056           1605       291     2239           1754       285
8   2013     1     3     2008           1540       268     2339           1909       270
9   2013     1     3     2012           1600       252     2314           1857       257
10  2013     1     4     2123           1635       288     2332           1856       276
..   ...   ...   ...      ...            ...       ...      ...            ...       ...
Variables not shown: carrier (chr), flight (int), tailnum (chr), origin (chr), dest
(chr), air_time (dbl), distance (dbl), hour (dbl), minute (dbl), time_hour (time)
> flights %>% group_by(month, day)  %>% arrange(desc(dep_delay)) %>% top_n(3, dep_delay)
Source: local data frame [1,108 x 19]
Groups: month, day [365]

year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time arr_delay
(int) (int) (int)    (int)          (int)     (dbl)    (int)          (int)     (dbl)
1   2013     1     1      848           1835       853     1001           1950       851
2   2013     1     1     2343           1724       379      314           1938       456
3   2013     1     1     1815           1325       290     2120           1542       338
4   2013     1     2     2131           1512       379     2340           1741       359
5   2013     1     2     1607           1030       337     2003           1355       368
6   2013     1     2     1412            838       334     1710           1147       323
7   2013     1     3     2056           1605       291     2239           1754       285
8   2013     1     3     2008           1540       268     2339           1909       270
9   2013     1     3     2012           1600       252     2314           1857       257
10  2013     1     4     2123           1635       288     2332           1856       276
..   ...   ...   ...      ...            ...       ...      ...            ...       ...
Variables not shown: carrier (chr), flight (int), tailnum (chr), origin (chr), dest
(chr), air_time (dbl), distance (dbl), hour (dbl), minute (dbl), time_hour (time)
> mtcars %>% head()
mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
> mtcars %>% add_rownames("model") %>% head()
Source: local data frame [6 x 12]

model   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
(chr) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl)
1         Mazda RX4  21.0     6   160   110  3.90 2.620 16.46     0     1     4     4
2     Mazda RX4 Wag  21.0     6   160   110  3.90 2.875 17.02     0     1     4     4
3        Datsun 710  22.8     4   108    93  3.85 2.320 18.61     1     1     4     1
4    Hornet 4 Drive  21.4     6   258   110  3.08 3.215 19.44     1     0     3     1
5 Hornet Sportabout  18.7     8   360   175  3.15 3.440 17.02     0     0     3     2
6           Valiant  18.1     6   225   105  2.76 3.460 20.22     1     0     3     1
> mtcars %>% head()
mpg cyl disp  hp drat    wt  qsec vs am gear carb
Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1
> mtcars %>% add_rownames("model") %>% tbl_df()
Source: local data frame [32 x 12]

model   mpg   cyl  disp    hp  drat    wt  qsec    vs    am  gear  carb
(chr) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl) (dbl)
1          Mazda RX4  21.0     6 160.0   110  3.90 2.620 16.46     0     1     4     4
2      Mazda RX4 Wag  21.0     6 160.0   110  3.90 2.875 17.02     0     1     4     4
3         Datsun 710  22.8     4 108.0    93  3.85 2.320 18.61     1     1     4     1
4     Hornet 4 Drive  21.4     6 258.0   110  3.08 3.215 19.44     1     0     3     1
5  Hornet Sportabout  18.7     8 360.0   175  3.15 3.440 17.02     0     0     3     2
6            Valiant  18.1     6 225.0   105  2.76 3.460 20.22     1     0     3     1
7         Duster 360  14.3     8 360.0   245  3.21 3.570 15.84     0     0     3     4
8          Merc 240D  24.4     4 146.7    62  3.69 3.190 20.00     1     0     4     2
9           Merc 230  22.8     4 140.8    95  3.92 3.150 22.90     1     0     4     2
10          Merc 280  19.2     6 167.6   123  3.92 3.440 18.30     1     0     4     4
..               ...   ...   ...   ...   ...   ...   ...   ...   ...   ...   ...   ...
> flights  %>% group_by(month)  %>% summarize(cnt=n())
Source: local data frame [12 x 2]

month   cnt
(int) (int)
1      1 27004
2      2 24951
3      3 28834
4      4 28330
5      5 28796
6      6 28243
7      7 29425
8      8 29327
9      9 27574
10    10 28889
11    11 27268
12    12 28135
> flights %>% group_by(month) %>% summarise(cnt = n())
Source: local data frame [12 x 2]

month   cnt
(int) (int)
1      1 27004
2      2 24951
3      3 28834
4      4 28330
5      5 28796
6      6 28243
7      7 29425
8      8 29327
9      9 27574
10    10 28889
11    11 27268
12    12 28135
> flights %>% group_by(month) %>% tally()
Source: local data frame [12 x 2]

month     n
(int) (int)
1      1 27004
2      2 24951
3      3 28834
4      4 28330
5      5 28796
6      6 28243
7      7 29425
8      8 29327
9      9 27574
10    10 28889
11    11 27268
12    12 28135
> flights %>% count(month)
Source: local data frame [12 x 2]

month     n
(int) (int)
1      1 27004
2      2 24951
3      3 28834
4      4 28330
5      5 28796
6      6 28243
7      7 29425
8      8 29327
9      9 27574
10    10 28889
11    11 27268
12    12 28135
> 
> flights %>% group_by(month, day) %>% summarise(cnt = n()) %>% arrange(desc(cnt)) %>% print(n = 40)
Source: local data frame [365 x 3]
Groups: month [12]

month   day   cnt
(int) (int) (int)
1      1     2   943
2      1     7   933
3      1    10   932
4      1    11   930
5      1    14   928
6      1    31   928
7      1    17   927
8      1    24   925
9      1    18   924
10     1    28   923
11     1    25   922
12     1     4   915
13     1     3   914
14     1    21   912
15     1     9   902
16     1    16   901
17     1    30   900
18     1     8   899
19     1    23   897
20     1    15   894
21     1    22   890
22     1    29   890
23     1     1   842
24     1     6   832
25     1    13   828
26     1    27   823
27     1    20   786
28     1     5   720
29     1    12   690
30     1    26   680
31     1    19   674
32     2    28   964
33     2    21   961
34     2    25   961
35     2    22   957
36     2    14   956
37     2    15   954
38     2    20   949
39     2    18   948
40     2    27   945
..   ...   ...   ...
> flights %>% group_by(month, day) %>% summarise(cnt = n()) %>% ungroup() %>% arrange(desc(cnt))
Source: local data frame [365 x 3]

month   day   cnt
(int) (int) (int)
1     11    27  1014
2      7    11  1006
3      7     8  1004
4      7    10  1004
5     12     2  1004
6      7    18  1003
7      7    25  1003
8      7    12  1002
9      7     9  1001
10     7    17  1001
..   ...   ...   ...
> 
> 
> (a <- data_frame(color = c("green","yellow","red"), num = 1:3))
Source: local data frame [3 x 2]

color   num
(chr) (int)
1  green     1
2 yellow     2
3    red     3
> (b <- data_frame(color = c("green","yellow","pink"), size = c("S","M","L")))
Source: local data frame [3 x 2]

color  size
(chr) (chr)
1  green     S
2 yellow     M
3   pink     L
> 
> inner_join(a, b)
Joining by: "color"
 Source: local data frame [2 x 3]
 
 color   num  size
 (chr) (int) (chr)
 1  green     1     S
 2 yellow     2     M
 > full_join(a, b)
 Joining by: "color"
 Source: local data frame [4 x 3]
 
 color   num  size
 (chr) (int) (chr)
 1  green     1     S
 2 yellow     2     M
 3    red     3    NA
 4   pink    NA     L
 > outer_join(a, b)
 Error: could not find function "outer_join"
 > outter_join(a, b)
 Error: could not find function "outter_join"
 > left_join(a, b)
 Joining by: "color"
 Source: local data frame [3 x 3]
 
 color   num  size
 (chr) (int) (chr)
 1  green     1     S
 2 yellow     2     M
 3    red     3    NA
 > 
   > 
   > 
   > # include all observations found in "b"
   > right_join(a, b)
 Joining by: "color"
 Source: local data frame [3 x 3]
 
 color   num  size
 (chr) (int) (chr)
 1  green     1     S
 2 yellow     2     M
 3   pink    NA     L
 > 
   > 
   > 
   > # right_join(a, b) is identical to left_join(b, a) except for column ordering
   > left_join(b, a)
 Joining by: "color"
 Source: local data frame [3 x 3]
 
 color  size   num
 (chr) (chr) (int)
 1  green     S     1
 2 yellow     M     2
 3   pink     L    NA
 > 
   > 
   > # filter "a" to only show observations that match "b"
   > semi_join(a, b)
 Joining by: "color"
 Source: local data frame [2 x 2]
 
 color   num
 (chr) (int)
 1  green     1
 2 yellow     2
 > 
   > 
   > 
   > # filter "a" to only show observations that don't match "b"
   > anti_join(a, b)
 Joining by: "color"
 Source: local data frame [1 x 2]
 
 color   num
 (chr) (int)
 1   red     3