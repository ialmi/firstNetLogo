globals [
  perc-red ;; used to store the percentage of red agents
  min-neigh
  max-neigh
  number-sources

]

breed [ cells cell ]

cells-own [
  one-neighbors  ;; agentset of directly neighboring cells
  two-neighbors  ;; agentset of neighbors with radius 2
  all-neighbors  ;; agentset of neighbors
  n              ;; used to store a count of red neighbors
  m              ;; used to store a count of white neighbors
  ;comfortable    ;;
  persuasiveness ;; used to store the persuasiveness of the agent (ability to change others' opinion)
  supportiveness  ;; used to store the suportiveness of the agent (ability to help others maintain their opinion)
  persuasiveness-impact
  supportiveness-impact
  pers
  sup
  taken?
]

to setup
  clear-all
  ifelse hexagonal?
    [setup-hex]
    [setup-square]
  set perc-red percentage-red

  ask patches
    [ ask cells-here
      [ifelse random 100 < percentage-red
        [set color red ]
        [set color white] ]]
  let cnt-red count cells with [color = red]
  let cnt-tot count cells
  set perc-red cnt-red / cnt-tot * 100

  if simple? [get-number-sources]

  reset-ticks

end


to get-number-sources
let nrsources user-input "How many neighbors of a different view will make an agent change opinion?"

  carefully
    [let nr-sources read-from-string nrsources
     ifelse nr-sources >= min-neigh and nr-sources <= max-neigh
       [set number-sources nr-sources]
       [user-message (word "Please type in an integer between " min-neigh " and "  max-neigh)]]

    [user-message (word "Please type in an integer between " min-neigh " and "  max-neigh)]


end

to setup-hex
  set-default-shape cells "box"
  ifelse radius-2?
      [set min-neigh  9
      set max-neigh  18]
      [set min-neigh  3
      set max-neigh  6]
  ask patches
    [if random 100 < density
      [ sprout-cells 1
        [ set color gray - 3  ;; dark gray
          ;; shift even columns down
          if pxcor mod 2 = 0
              [ set ycor ycor - 0.5 ]
          set persuasiveness random 100
          set supportiveness random 100] ]]
  ;; now set up the 1-neighbors agentsets
  ask cells
    [ ifelse pxcor mod 2 = 0
        [ set one-neighbors cells-on patches at-points [[0 1] [1 0] [1 -1] [0 -1] [-1 -1] [-1 0]]
          set two-neighbors cells-on patches at-points [[0 1] [1 0] [1 -1] [0 -1] [-1 -1] [-1 0]
          [0 2] [1 1] [2 1] [2 0] [2 -1] [1 -2] [0 -2] [-1 -2] [-2 -1] [-2 0] [-2 1] [-1 1]]
        ]
        [ set one-neighbors cells-on patches at-points [[0 1] [1 1] [1  0] [0 -1] [-1  0] [-1 1]]
          set two-neighbors cells-on patches at-points [[0 1] [1 1] [1  0] [0 -1] [-1  0] [-1 1]
          [0 2] [1 2] [2 1] [2 0] [2 -1] [1 -1] [0 -2] [-1 -1] [-2 -1] [-2 0] [-2 1] [-1 2]]
        ]
     ]
end

to setup-square
  set-default-shape cells "square"
  ifelse radius-2?
      [set min-neigh  12
       set max-neigh  24]
      [set min-neigh  4
       set max-neigh  8]
  ask patches
    [if random 100 < density
      [ sprout-cells 1
        [ set color gray - 3  ;; dark gray
          set persuasiveness random 100
          set supportiveness random 100] ]]
  ;; now set up the 1-neighbors agentsets
  ask cells
        [ set one-neighbors cells-on patches at-points [[0 1] [1 1] [1 0] [1 -1] [0 -1] [-1 -1] [-1 0] [-1 1]]
          set two-neighbors cells-on patches at-points [[0 1] [1 1] [1 0] [1 -1] [0 -1] [-1 -1] [-1 0] [-1 1]
            [0 2] [1 2] [2 2][2 1] [2 0] [2 -1] [2 -2] [1 -2] [0 -2] [-1 -2] [-2 -2] [-2 -1] [-2 0] [-2 1] [-2 2] [-1 2]]
        ]

end

to setup-ajax
  clear-all
  set hexagonal? false
  ;setup-grid
  set perc-red percentage-red

  set-default-shape cells "square"
  ask patches
      [ sprout-cells 1
        [ set persuasiveness random 100
          set supportiveness random 100
          set taken? false ] ]
  ;; now set up the 1-neighbors agentsets
  ask cells
        [ set one-neighbors cells-on patches at-points [[0 1] [1 1] [1 0] [1 -1] [0 -1] [-1 -1] [-1 0] [-1 1]]
          set two-neighbors cells-on patches at-points [[0 1] [1 1] [1 0] [1 -1] [0 -1] [-1 -1] [-1 0] [-1 1]
            [0 2] [1 2] [2 2][2 1] [2 0] [2 -1] [2 -2] [1 -2] [0 -2] [-1 -2] [-2 -2] [-2 -1] [-2 0] [-2 1] [-2 2] [-1 2]]
          ]
  let cells-ajax-random cells with [xcor < 3 or xcor > 36 or ycor < 13 or ycor > 27]
  let cells-ajax-white cells with [ (xcor = 4 and (ycor > 16 and ycor < 26)) or
                                    (xcor = 5 and (ycor > 16 and ycor < 27)) or
                                    (xcor = 6 and (ycor = 20 or ycor = 24 or ycor = 25 or ycor = 26)) or
                                    (xcor = 7 and (ycor = 20 or ycor = 24 or ycor = 25 or ycor = 26)) or
                                    (xcor = 8 and (ycor > 16 and ycor < 27)) or
                                    (xcor = 9 and (ycor > 16 and ycor < 26)) or
                                    (xcor = 11 and (ycor = 15 or ycor = 16)) or
                                    (xcor = 12 and (ycor > 13 and ycor < 17)) or
                                    (xcor = 13 and (ycor = 14 or ycor = 15)) or
                                    (xcor = 14 and (ycor = 14 or ycor = 15)) or
                                    (xcor = 15 and (ycor > 13 and ycor < 27)) or
                                    (xcor = 16 and (ycor > 14 and ycor < 27)) or
                                    (xcor = 19 and (ycor > 16 and ycor < 26)) or
                                    (xcor = 20 and (ycor > 16 and ycor < 27)) or
                                    (xcor = 21 and (ycor = 20 or ycor = 24 or ycor = 25 or ycor = 26)) or
                                    (xcor = 22 and (ycor = 20 or ycor = 24 or ycor = 25 or ycor = 26)) or
                                    (xcor = 23 and (ycor > 16 and ycor < 27)) or
                                    (xcor = 24 and (ycor > 16 and ycor < 26)) or
                                    (xcor = 27 and (ycor = 17 or ycor = 18 or ycor = 25 or ycor = 26)) or
                                    (xcor = 28 and ((ycor > 16 and ycor < 21) or (ycor > 22 and ycor < 27))) or
                                    (xcor = 29 and (ycor > 16 and ycor < 27)) or
                                    (xcor = 30 and (ycor > 18 and ycor < 25)) or
                                    (xcor = 31 and (ycor = 21 or ycor = 22)) or
                                    (xcor = 32 and (ycor > 18 and ycor < 25)) or
                                    (xcor = 33 and (ycor > 16 and ycor < 27)) or
                                    (xcor = 34 and ((ycor > 16 and ycor < 21) or (ycor > 22 and ycor < 27))) or
                                    (xcor = 35 and (ycor = 17 or ycor = 18 or ycor = 25 or ycor = 26))
    ]


 ask cells-ajax-white
    [set color white
     set taken? true]
 ask cells-ajax-random
    [set taken? true
     ifelse random 100 < percentage-red
        [set color red ]
        [set color white] ]
 let cells-ajax-red cells with [ taken? = false]
 ask cells-ajax-red
    [set color red
     set taken? true]
 let cnt-red count cells with [color = red]
  print cnt-red
 let cnt-tot count cells
 set perc-red cnt-red / cnt-tot * 100
   ifelse radius-2?
      [set min-neigh  12
       set max-neigh  24]
      [set min-neigh  4
       set max-neigh  8]

  if simple? [get-number-sources]

 reset-ticks

end



to go

ifelse simple?
  [simple] ;; run the simple model
  [nowak-latane] ;; run the Nowak-Latané model

  update-globals

  tick
end


to nowak-latane
  compute-for-agents
  ask cells
    [ifelse  color = white
      [if persuasiveness-impact > supportiveness-impact
        [ set color red
          set persuasiveness random 100
          set supportiveness random 100 ] ]
      [if persuasiveness-impact > supportiveness-impact
        [ set color white
          set persuasiveness random 100
          set supportiveness random 100 ]]
  ]
end


to simple
    ask cells
    [ifelse radius-2?
      [set all-neighbors two-neighbors]
      [set all-neighbors one-neighbors]
    set n count all-neighbors with [color = red]
    set m count all-neighbors with [color = white] ]

  let whites cells with [color = white]
  let reds cells with [color = red]

  ask whites
  [ if n >= Number-sources
        [ set color red ] ]

  ask reds
  [ if m >= Number-sources
        [ set color white ] ]
end

to compute-for-agents
  ask cells
    [ let different cells with [ color != [ color ] of myself ]
      let same cells with [color = [color] of myself]

      let mainx xcor
      let mainy ycor

      ask different
        [if distancexy mainx mainy > 0
          [ set pers [persuasiveness] of myself / (( distancexy mainx mainy ) * (distancexy mainx mainy))]]
      ifelse count(different) > 0
         [set persuasiveness-impact sqrt(count different ) * sum([pers] of different) / count(different)
            ]
         [set persuasiveness-impact 0]


      ask same
        [if distancexy mainx mainy > 0
          [set sup [supportiveness] of myself / (( distancexy mainx mainy ) * (distancexy mainx mainy))]]
      ifelse count(same) > 0
        [set supportiveness-impact sqrt(count same ) * sum([sup] of same) / count(same)
           ]
        [set supportiveness-impact 0]
  ]
end



to update-globals
  let cnt-red count cells with [color = red]
  let cnt-tot count cells
  set perc-red cnt-red / cnt-tot * 100

end
@#$#@#$#@
GRAPHICS-WINDOW
489
10
939
461
-1
-1
11.05
1
10
1
1
1
0
0
0
1
0
39
0
39
1
1
1
iterations
30.0

BUTTON
6
11
61
44
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
124
11
182
44
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
6
193
181
226
percentage-red
percentage-red
1
100
70.0
1
1
NIL
HORIZONTAL

PLOT
6
286
485
461
Opinion: red
NIL
NIL
0.0
10.0
0.0
100.0
true
false
"" ""
PENS
"default" 1.0 0 -2674135 true "" "plot perc-red"

SLIDER
5
132
181
165
density
density
0
100
48.0
1
1
NIL
HORIZONTAL

SWITCH
381
194
485
227
radius-2?
radius-2?
1
1
-1000

SWITCH
272
80
375
113
simple?
simple?
0
1
-1000

SWITCH
6
87
182
120
hexagonal?
hexagonal?
1
1
-1000

TEXTBOX
6
56
175
84
Do you want hexagonal or square agents?
11
0.0
1

TEXTBOX
224
10
469
70
The default model is based on Nowak, Szamrej & Latané (1990). Select if you want to use only the influence of immediate and second order neighbors
12
0.0
1

TEXTBOX
208
192
373
235
Do second-order neighbors have an influence?
11
0.0
1

TEXTBOX
7
178
175
206
Starting % of red agents
11
0.0
1

TEXTBOX
206
231
384
272
Minimum number of neighbors with a different view who will make an agent change opinion:
11
0.0
1

TEXTBOX
253
157
436
177
Only for the \"simple\" model:
13
0.0
1

BUTTON
64
11
119
44
AJAX
setup-ajax
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
6
232
182
277
Current % of red agents
perc-red
2
1
11

MONITOR
380
231
485
276
NIL
number-sources
0
1
11

@#$#@#$#@
## WHAT IS IT?

This is a simulation of a Nowak-Latané (Nowak, Szamrej&Latané, 1990)  model of opinion dynamics. In addition to the original model, it offers the possibility of manipulating density and arrangement of agents (grid of square or of hexagons). The user has also the option of using a simple model, that only takes into account neighbors, with all neighbors having the same persuasiveness and supportiveness.

## HOW IT WORKS

Agents can have one of 2 opinions (red or white). 

EXPLAIN NOWAK_LATANE HERE!

In the "simple" model, they change their opinion based on the opinion of neighboring agents. The user can select who are the neighbors (only immediate, or also the second "circle"), and how many agents of a divergent opinion an agent needs to have in their neighborhood in order to change their opinion.

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.4
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
