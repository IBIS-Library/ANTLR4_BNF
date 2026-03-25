// Copyright (c) 2026 Intel Corp.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, 
// this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice, 
// this list of conditions and the following disclaimer in the documentation 
// and/or other materials provided with the distribution.
//
// 3. Neither the name of the copyright holder nor the names of its contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS” 
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
// POSSIBILITY OF SUCH DAMAGE.
//

//grammar definition for IBIS

grammar ibis2p0_igpt;

// Parser Rules
ibisfile
    : ibisfileheader sections '[' 'End' ']'
    ;

packagefile
    : packagefileheader packagedefinitionsections '[' 'End' ']'
    ;

ibisfileheader
    : LINE_COMMENT* ibisversion LINE_COMMENT* ibisfilename LINE_COMMENT* fileversion LINE_COMMENT* fileheaderitems
	| LINE_COMMENT* ibisversion LINE_COMMENT* commentchar* LINE_COMMENT* ibisfilename LINE_COMMENT* fileversion LINE_COMMENT* fileheaderitems
	| LINE_COMMENT* ibisversion LINE_COMMENT* ibisfilename LINE_COMMENT* commentchar* LINE_COMMENT* fileversion LINE_COMMENT* fileheaderitems
	;

packagefileheader
    : ibisversion packagefilename fileversion fileheaderitems
    ;

// Not every possibility is listed below
fileheaderitems
    : date? source? notes? disclaimer? copyright?
    | source? date? notes? disclaimer? copyright?
    | source? notes? date? disclaimer? copyright?
	| source? notes? date? copyright? disclaimer? 
    ;

ibisversion
    : '[' 'IBIS' 'Ver' ']' '1.0'
	| '[' 'IBIS' 'Ver' ']' '1.1'
	| '[' 'IBIS' 'Ver' ']' '2.0'
	| '[' 'IBIS' 'Ver' ']' '2.1'
	| '[' 'IBIS' 'Ver' ']' '3.0'
	| '[' 'IBIS' 'Ver' ']' '3.1'	
	| '[' 'IBIS' 'Ver' ']' '3.2'
    ;

commentchar
    : '[' 'Comment' 'Char' ']' comment_character '_char'
    ;

//commentstring
//    : comment_character '_char'
//    ;

comment_character
    : '!' | '"' | '#' | '$' | '%' | '&' | '\'' | '(' | ')' | '*' | ',' | ':' | ';' | '<' | '>' | '?' | '@' | '\\' | '^' | '`' | '{' | '|' | '}' | '~'
    ;

ibisfilename
    : '[' 'File' 'Name' ']' ibisfilenamestring
    ;

ibisfilenamestring
    : STRING8 '.ibs'
    ;

packagefilename
    : '[' 'File' 'Name' ']' packagefilenamestring
    ;

packagefilenamestring
    : STRING8 '.pkg'
    ;

fileversion
    : '[' 'File' 'Rev' ']' STRING
    ;

date
    : '[' 'Date' ']' STRING40
    ;

source
    : '[' 'Source' ']' STRING
    ;

notes
    : '[' 'Notes' ']' STRING
    ;

disclaimer
    : '[' 'Disclaimer' ']' STRING
	| '[' 'Disclaimer' ']' LINE_COMMENT*
    ;

copyright
    : '[' 'Copyright' ']' STRING
	| '[' 'Copyright' ']' LINE_COMMENT*
    ;

sections
    : componentdefinitionsection modeldefinitionsections? packagedefinitionsection?
    ;

modeldefinitionsections
    : modeldefinitionsection+
    ;

packagedefinitionsections
    : packagedefinitionsection+
    ;

componentdefinitionsection
    : component LINE_COMMENT* manufacturer LINE_COMMENT* package LINE_COMMENT* pin LINE_COMMENT* package_model? LINE_COMMENT* pin_mapping? LINE_COMMENT* diff_pin?
    ;

component
    : '[' 'Component' ']' STRING40
    ;

manufacturer
    : '[' 'Manufacturer' ']' STRING40
    ;

package
    : '[' 'Package' ']' package_rlc
    ;

package_rlc
    : 'R_pkg' typ_min_max 'L_pkg' typ_min_max 'C_pkg' typ_min_max
    ;

typ_min_max
    : REAL real_na real_na
    ;

real_na
    : REAL | 'na'
    ;

real_na9
    : REAL9 | 'na'
    ;

pin
    : pin_wpi | pin_data
    ;

pin_wpi
    : pin_header rlc_pin_heading pin_entry_set_wpi
    ;

rlc_pin_heading
    : 'R_pin' 'L_pin' 'C_pin'
    | 'R_pin' 'C_pin' 'L_pin'
    | 'L_pin' 'C_pin' 'R_pin'
    | 'L_pin' 'R_pin' 'C_pin'
    | 'C_pin' 'R_pin' 'L_pin'
    | 'C_pin' 'L_pin' 'R_pin'
    ;

pin_data
    : pin_header pin_entry_set
    ;

pin_header
    : '[' 'Pin' ']' 'signal_name' 'model_name'
    ;

pin_entry_set_wpi
    : pin_entry_wpi+
    ;

pin_entry_set
    : pin_entry+
    ;

pin_entry_wpi
    : pin_entry (real_na9 real_na9 real_na9)?
    ;

pin_entry
    : pin_identifier signal_identifier model_identifier
    ;

pin_identifier
    : STRING5
    ;

signal_identifier
    : STRING20
    ;

model_identifier
    : STRING20 | 'power' | 'gnd' | 'nc'
    ;

package_model
    : '[' 'Package' 'Model' ']' STRING40
    ;

pin_mapping
    : pin_mapping_wr | pin_mapping_data
    ;

pin_mapping_wr
    : pin_mapping_header clamp_ref_name pin_mapping_value_set_wr
    ;

pin_mapping_data
    : pin_mapping_header pin_mapping_value_set
    ;

pin_mapping_header
    : '[' 'pin' 'mapping' ']' 'pulldown_ref' 'pullup_ref'
    ;

clamp_ref_name
    : 'gnd_clamp_ref' 'power_clamp_ref'
    ;

pin_mapping_value_set
    : pin_mapping_values+
    ;

pin_mapping_value_set_wr
    : pin_mapping_values_wr+
    ;

pin_mapping_values_wr
    : pin_identifier bus_name bus_name (bus_name bus_name)?
    ;

pin_mapping_values
    : pin_identifier bus_name bus_name
    ;

bus_name
    : STRING15 | 'nc'
    ;

diff_pin
    : diff_pin_wr | diff_pin_data
    ;

diff_pin_wr
    : diff_pin_header delay_range_name diff_pin_value_set_wr
    ;

diff_pin_data
    : diff_pin_header diff_pin_value_set
    ;

diff_pin_header
    : '[' 'diff_pin' ']' 'inv_pin' 'vdiff' 'tdelay_typ'
    ;

delay_range_name
    : 'tdelay_min' 'tdelay_max'
    ;

diff_pin_value_set
    : diff_pin_values+
    ;

diff_pin_value_set_wr
    : diff_pin_values_wr+
    ;

diff_pin_values_wr
    : diff_pin_values (real_na9 real_na9)?
    ;

diff_pin_values
    : STRING5 STRING5 REAL9 real_na9
    ;

modeldefinitionsection
    : '[' 'model' ']' model_name model
    ;

model_name
    : STRING20
    ;

model
    : model_of_type_one | model_of_type_two | model_of_type_terminator
    ;

model_of_type_one
    : modeltype_one modelentry_one
    ;

model_of_type_two
    : modeltype_two modelentry_two
    ;

model_of_type_terminator
    : modeltype_terminator modelentry_terminator
    ;

modeltype_one
    : 'Model_type' modeltype_one_identifier
    ;

modeltype_one_identifier
    : 'Input' | 'I/O' | 'I/O_open_drain' | 'I/O_open_sink' | 'I/O_open_source' | 'Input_ECL' | 'I/O_ECL'
    ;

modeltype_two
    : 'Model_type' modeltype_two_identifier
    ;

modeltype_two_identifier
    : '3-state' | 'Open_sink' | 'Open_drain' | 'Open_source' | 'Output' | 'Output_ECL'
    ;

modeltype_terminator
    : 'Model_type' 'Terminator'
    ;

modelentry_one
    : c_comp vinl vinh modelentry
    ;

modelentry_two
    : c_comp modelentry
    ;

modelentry_terminator
    : c_comp modelentry
    ;

modelentry
    : polarity? enable? vmeas? cref? rref? vref? temperature_range? model_range? pulldown? pullup? gndclamp? powerclamp? rpower? rgnd? ramp? rac? cac? waveformtable?
    ;

model_range
    : voltage_range
    | all_model_refs
    | voltage_range model_refs
    ;

all_model_refs
    : pullup_reference pulldown_reference gnd_clamp_reference power_clamp_reference
    ;

model_refs
    : pullup_reference? pulldown_reference? gnd_clamp_reference? power_clamp_reference?
    ;

c_comp
    : 'C_comp' typ_min_max
    ;

polarity
    : 'Polarity' ('Non-Inverting' | 'Inverting')?
    ;

enable
    : 'Enable' ('Active-High' | 'Active-Low')?
    ;

vinl
    : 'Vinl' '=' voltage_spec
    ;

vinh
    : 'Vinh' '=' voltage_spec
    ;

vmeas
    : 'Vmeas' '=' voltage_spec
    ;

cref
    : 'Cref' '=' capacitance_spec
    ;

rref
    : 'Rref' '=' resistance_spec
    ;

vref
    : 'Vref' '=' voltage_spec
    ;

voltage_spec
    : REAL
    ;

capacitance_spec
    : REAL
    ;

resistance_spec
    : REAL
    ;

temperature_range
    : '[' 'Temperature' 'Range' ']' typ_min_max
    ;

voltage_range
    : '[' 'Voltage' 'Range' ']' typ_min_max
    ;

pullup_reference
    : '[' 'Pullup' 'Reference' ']' typ_min_max
    ;

pulldown_reference
    : '[' 'Pulldown' 'Reference' ']' typ_min_max
    ;

power_clamp_reference
    : '[' 'POWER' 'Clamp' 'Reference' ']' typ_min_max
    ;

gnd_clamp_reference
    : '[' 'GND' 'Clamp' 'Reference' ']' typ_min_max
    ;

pulldown
    : '[' 'Pulldown' ']' videfinitions
    ;

pullup
    : '[' 'Pullup' ']' videfinitions
    ;

gndclamp
    : '[' 'GND_clamp' ']' videfinitions
    ;

powerclamp
    : '[' 'Power_clamp' ']' videfinitions
    ;

rpower
    : '[' 'rpower' ']' typ_min_max
    ;

rgnd
    : '[' 'rgnd' ']' typ_min_max
    ;

videfinitions
    : videfinition+
    ;

videfinition
    : REAL typ_min_max
    ;

ramp
    : '[' 'Ramp' ']' dvdtr dvdtf r_load?
    ;

dvdtr
    : 'dV/dt_r' typ_min_max_rate
    ;

dvdtf
    : 'dV/dt_f' typ_min_max_rate
    ;

r_load
    : 'R_load' '=' REAL
    ;

typ_min_max_rate
    : rate (rate | 'na')? (rate | 'na')?
    ;

rac
    : '[' 'rac' ']' typ_min_max
    ;

cac
    : '[' 'cac' ']' typ_min_max
    ;

waveformtable
    : waveform_data*
    ;

waveform_data
    : ('[' 'Rising' 'Waveform' ']' | '[' 'Falling' 'Waveform' ']') waveform_header waveform_table
    ;

waveform_header
    : r_fixture v_fixture c_fixture? l_fixture? r_dut? l_dut? c_dut? v_fixture_min? v_fixture_max?
    ;

r_fixture
    : 'R_fixture' '=' REAL
    ;

v_fixture
    : 'V_fixture' '=' REAL
    ;

v_fixture_min
    : 'V_fixture_min' '=' REAL
    ;

v_fixture_max
    : 'V_fixture_max' '=' REAL
    ;

c_fixture
    : 'C_fixture' '=' REAL
    ;

l_fixture
    : 'L_fixture' '=' REAL
    ;

r_dut
    : 'R_dut' '=' REAL
    ;

l_dut
    : 'L_dut' '=' REAL
    ;

c_dut
    : 'C_dut' '=' REAL
    ;

waveform_table
    : waveform_point*
    ;

waveform_point
    : time_point typ_min_max
    ;

time_point
    : REAL
    ;

rate
    : REAL '/' REAL
    ;

packagedefinitionsection
    : definepackage package_header package_description endpackage
    ;

definepackage
    : '[' 'define' 'package' 'model' ']' STRING40
    ;

package_header
    : manufacturer oem description number_pins pin_numbers pin_names
    ;

oem
    : '[' 'oem' ']' STRING40
    ;

description
    : '[' 'description' ']' STRING60
    ;

number_pins
    : '[' 'number' 'of' 'pins' ']' POS_INTEGER
    ;

pin_numbers
    : '[' 'pin' 'numbers' ']' pin_names
    ;

pin_names
    : pin_name+
    ;

pin_name
    : STRING5
    ;

package_description
    : '[' 'model' 'data' ']' model_body '[' 'end' 'model' 'data' ']'
    ;

model_body
    : inductance_matrix capacitance_matrix resistance_matrix?
    ;

inductance_matrix
    : '[' 'inductance' 'matrix' ']' matrix
    ;

capacitance_matrix
    : '[' 'capacitance' 'matrix' ']' matrix
    ;

resistance_matrix
    : '[' 'resistance' 'matrix' ']' matrix
    ;

matrix
    : full_matrix | banded_matrix | sparse_matrix
    ;

full_matrix
    : 'full' 'matrix' matrix_line+
    ;

banded_matrix
    : 'banded' 'matrix' bandwidth banded_matrix_line+
    ;

sparse_matrix
    : 'sparse' 'matrix' sparse_matrix_line+
    ;

bandwidth
    : '[' 'bandwidth' ']' POS_INTEGER
    ;

matrix_line
    : row REAL+
    ;

banded_matrix_line
    : row REAL
    ;

sparse_matrix_line
    : row STRING5 REAL (STRING5 REAL)*
    ;

row
    : '[' 'Row' ']' STRING5
    ;

endpackage
    : '[' 'End' 'Package' 'Model' ']'
    ;

// Lexer Rules
REAL
    : [+-]? DIGIT+ ('.' DIGIT+)? ([eE] [+-]? DIGIT+)? UNIT*
    ;

REAL9
    : [+-]? DIGIT+ ('.' DIGIT+)? ([eE] [+-]? DIGIT+)? UNIT* {getText().length() <= 9}?
    ;

POS_INTEGER
    : [1-9] DIGIT*
    ;

STRING5
    : '"' ~["\r\n]* '"' {getText().length() <= 7}?  // 5 chars + 2 quotes
    | [a-zA-Z0-9_]+ {getText().length() <= 5}?
    ;

STRING8
    : '"' ~["\r\n]* '"' {getText().length() <= 10}? // 8 chars + 2 quotes
    | [a-zA-Z0-9_]+ {getText().length() <= 8}?
    ;

STRING15
    : '"' ~["\r\n]* '"' {getText().length() <= 17}? // 15 chars + 2 quotes
    | [a-zA-Z0-9_]+ {getText().length() <= 15}?
    ;

STRING20
    : '"' ~["\r\n]* '"' {getText().length() <= 22}? // 20 chars + 2 quotes
    | [a-zA-Z0-9_]+ {getText().length() <= 20}?
    ;

STRING40
    : '"' ~["\r\n]* '"' {getText().length() <= 42}? // 40 chars + 2 quotes
    | [a-zA-Z0-9_]+ {getText().length() <= 40}?
    ;

STRING60
    : '"' ~["\r\n]* '"' {getText().length() <= 62}? // 60 chars + 2 quotes
    | [a-zA-Z0-9_]+ {getText().length() <= 60}?
    ;

STRING
    //: '"' ~["\r\n]* '"'
    //| [a-zA-Z0-9_:.]+
	: ~[\r\n\t \u00A0[\]=/]+  // any non-whitespace, excluding [, ], =, /
    ;

UNIT
    : [fpnumkMGT]
    ;

fragment DIGIT
    : [0-9]
    ;

// Comments

// This syntax allows complete comments lines or in-line comments
LINE_COMMENT
    : '|' ~[\r\n]* '\r'? '\n' -> skip
    ;

// COMMENT
// Below line was incorrect, as comment was read from BNF and not from IBIS
//    : '//' ~[\r\n]* -> skip 
//    ;

// Whitespace
WS
    : [ \t\r\n]+ -> skip
    ;

// Brackets and other punctuation
LBRACKET : '[' ;
RBRACKET : ']' ;
EQUALS : '=' ;
SLASH : '/' ;
DOT : '.' ;
UNDERSCORE : '_' ;

fragment A: [aA]; fragment B: [bB]; fragment C: [cC]; fragment D: [dD];
fragment E: [eE]; fragment F: [fF]; fragment G: [gG]; fragment H: [hH];
fragment I: [iI]; fragment J: [jJ]; fragment K: [kK]; fragment L: [lL];
fragment M: [mM]; fragment N: [nN]; fragment O: [oO]; fragment P: [pP];
fragment Q: [qQ]; fragment R: [rR]; fragment S: [sS]; fragment T: [tT];
fragment U: [uU]; fragment V: [vV]; fragment W: [wW]; fragment X: [xX];
fragment Y: [yY]; fragment Z: [zZ];