# python compile.py -s {spy_enabled:[True]/False} -i {input:[asm_code.txt]} -t {template:[instruction_templates.txt]} -v {vhdl_template:[vhdl_tb_template.txt]} -o {output:[controller_tb.vhd]}

import sys
import re 
import argparse
import os

REGISTER_NAMES = ['R0', 'R1', 'R2', 'R3', 'R4', 'R5', 'R6', 'R7', 'R8', 'R9', 'R10', 'R11', 'R12', 'R13']
RAM_CLOCK = "fast_clk_period"
RAM_DATA_SIGNAL = "TMP_DATA"
RAM_ADDRESS_SIGNAL = "TMP_ADR"

CURRENT_ADDRESS = 0
CURRENT_SEGMENT = None
SEGMENTS = []
DECLARATIONS = dict()
VARIABLES = dict()
RESULT = ""


def str2bool(v):
    if isinstance(v, bool):
        return v
    if v.lower() in ('yes', 'true', 't', 'y', '1'):
        return True
    elif v.lower() in ('no', 'false', 'f', 'n', '0'):
        return False
    else:
        raise argparse.ArgumentTypeError('Boolean value expected.')

parser = argparse.ArgumentParser(description='This script compiles asm to test bench for 16 bit FPGA-VHDL CPU.')
parser.add_argument('-t', '--template', 		default='instruction_templates.txt', help='File path for instruction templates.')
parser.add_argument('-i', '--input'	  , 		default='asm_code.txt'             , help='File path for assembly code.')
parser.add_argument('-v', '--vhdl_template', 	default='vhdl_tb_template.txt'     , help='File path for vhdl testbench template.')
parser.add_argument('-s', '--spy_enabled', 		default=True     				   , help='Status for spy_enabled.', type=str2bool, nargs='?')
parser.add_argument('-o', '--output'  , 		default='controller_tb.vhd'        , help='File path for output vhdl code.')

args = parser.parse_args()

if os.path.exists(args.vhdl_template):
	RESULT = open(args.vhdl_template).read()
else:
	print(f"Fatal: Could not find template file. {args.vhdl_template}")
	sys.exit(1)

if not args.spy_enabled:
	spy_split = RESULT.split('spy_process')
	RESULT = spy_split[0][:-1] + spy_split[2][2:]
	RESULT = RESULT.replace('USE modelsim_lib.util.ALL;\n', '')

if os.path.exists(args.template):
	op_templates = dict([o.split('\t') for o in open(args.template).read().split('\n')])
else:
	print(f"Fatal: Could not find template file. {args.template}")
	sys.exit(1)

if os.path.exists(args.input):
	asm = open(args.input).read()
else:
	print(f"Fatal: Could not find input(assembly) file. {args.input}")
	sys.exit(1)

def split_operation_line(operation):

	if operation[0].strip().endswith(':'):
		DECLARATIONS[operation[0].strip()[:-1].upper()] = CURRENT_ADDRESS
		return (False, None, None)

	if operation[0] not in op_templates.keys():
		print(f"Compile Failed: Undefined Operation '{operation[0]}'")
		sys.exit(1)

	op_template = op_templates[operation[0]]
	opcode = op_template[0:2]

	has_dst_2 = False

	if 'DS' in op_template:
		try:
			if "+" in op_template and len(operation) == 4:				
				dst = operation[2]
				src = operation[3]
				has_dst_2 = True
			else:
				dst = operation[1]
				src = operation[2]
		except:
			print(f"Compile Failed: Template Error '{operation}'")
			sys.exit(1)

	if 'DX' in op_template:
		if len(operation) == 2:
			dst = operation[1]
			src = None
		elif len(operation) == 3 and "+" in op_template:
			dst = operation[2]
			src = None
			has_dst_2 = True
		else:
			print(f"Compile Failed: Template Error '{operation}'")
			sys.exit(1)

	if 'XS' in op_template:
		if len(operation) == 2:
			dst = None
			src = operation[1]
		elif len(operation) == 3 and "+" in op_template:
			dst = None
			src = operation[2]
			has_dst_2 = True
		else:
			print(f"Compile Failed: Template Error '{operation}'")
			sys.exit(1)

	if 'XX' in op_template:
		if len(operation) == 1:
			dst = None
			src = None
		else:
			print(f"Compile Failed: Template Error '{operation}'")
			sys.exit(1)	

	if has_dst_2:
		dst2 = operation[1]
		if dst2.startswith('R') and dst2[1:].isdigit() and int(dst2[1:]) < 8:
			opcode = opcode[0] + hex(int(opcode[1]) + int(dst2[1:]))[2:].zfill(1).upper()
		else:
			print(f"Compile Failed: Template Error DST2 must be one of first 8 registers. '{operation}'")
			sys.exit(1)
	elif "+" in op_template:
		opcode = opcode[0] + hex(7 + int(opcode[1]))[2:].zfill(1).upper()


	return (opcode, dst, src)


def hex_calculator(value, ret_type = 'hex'):

	may_declaration = False

	try:
		value = value.upper()

		if value.endswith('H') or value.startswith('0X'):
			try:
				value = int(value.replace('H', '').replace('0X', ''), 16)
			except:
				may_declaration = True

		elif value.endswith('B') or value.startswith('B'):
			try:
				value = int(value.replace('B', '').replace('B', ''), 2)
			except:
				may_declaration = True

		elif value in DECLARATIONS:
			value = DECLARATIONS[value]
		elif value in VARIABLES:
			value = VARIABLES[value][1]
		elif value.startswith('@') and value[1:] in VARIABLES:
			value = VARIABLES[value[1:]][0]
		else:
			if value.isdigit():
				value = int(value)
			else:
				may_declaration = True
		if may_declaration:
			return "{" + value + "}"	

		if value > 2 ** 16 - 1:
			print(f"Compile Failed: The operand is too big '{value}'")
			sys.exit(1)

		if ret_type == 'hex':
			return hex(value)[2:].zfill(4).upper()
		elif ret_type == 'dec':
			return value
		else:
			return value

	except:
		print(f"Compile Failed: Wrong value '{value}'")
		sys.exit(1)	

def assign_operand(operand):

	if operand is None:
		return ("0", None)

	if operand in REGISTER_NAMES:
		try: 
			return (hex(int(operand.replace('R', '')))[2:].upper(), None)
		except:
			print(f"Compile Failed: Undefined register '{operand}'")
			sys.exit(1)	

	elif operand.startswith('[') and operand.endswith(']'):
		return ('F', hex_calculator(operand[1: -1]))
	else:
		return ('E', hex_calculator(operand))

def generate_tb_line(opcode, dst, src, optext):
	global CURRENT_ADDRESS

	line = f'\t{RAM_DATA_SIGNAL} <= x"{opcode}{dst[0]}{src[0]}";\tWAIT FOR {RAM_CLOCK};\t'

	if dst[1] != None and src[1] != None:
		print(f"Compile Failed: SRC and DST cannot be immediate or RAM as the same time.")
		sys.exit(1)	

	CURRENT_ADDRESS += 1

	if dst[1] != None:
		line = line + f'{RAM_DATA_SIGNAL} <= x"{dst[1]}";\tWAIT FOR {RAM_CLOCK};\t-- {optext}'
		CURRENT_ADDRESS += 1
	if src[1] != None:
		line = line + f'{RAM_DATA_SIGNAL} <= x"{src[1]}";\tWAIT FOR {RAM_CLOCK};\t-- {optext}'
		CURRENT_ADDRESS += 1

	if dst[1] == None and src[1] == None:
		line = line + " " * 46 + f"\t-- {optext}"
	return line

operations = [line.split('-')[0].strip().replace(' ', '\t').replace('\r', '\t').replace(',', '').split('\t') for line in asm.split('\n') if not line.startswith('--') and line != '']

def segment_divider(operation):
	global CURRENT_ADDRESS, CURRENT_SEGMENT, SEGMENTS

	if operation.upper().strip() == '[CODE]':
		CURRENT_ADDRESS = 0
		CURRENT_SEGMENT = 'CODE'
		SEGMENTS.append(CURRENT_SEGMENT)
		return True

	if operation.upper().strip().startswith('[DATA'):
		regx = re.findall('\[DATA\((.*)\)\]', operation.upper().strip())
		if len(regx) == 1:
			CURRENT_ADDRESS = hex_calculator(regx[0], 'dec')
			CURRENT_SEGMENT = 'DATA'
			SEGMENTS.append(CURRENT_SEGMENT)
			return True
		else:
			print(f"Compile Failed: DATA segment syntax is wrong. {operation}")
			sys.exit(1)
		return True
	return False

def operation_text(operation):
	txt = operation[0]

	if len(operation) > 1:
		txt = txt + " " + operation[1]
	if len(operation) > 2:
		txt = txt + ", " + operation[2]
	if len(operation) > 3:
		txt = txt + ", " + operation[3]
	return txt


def assign_variable(operation):
	global VARIABLES, CURRENT_ADDRESS

	if len(operation) != 3:
		print("Compile Failed: DATA VARIABLE syntax wrong. " + " ".join(operation))
		sys.exit(1)

	if operation[0][0].isdigit():
		print("Compile Failed: VARIABLE name cannot starts with a digit. " + " ".join(operation))
		sys.exit(1)

	if operation[0] in VARIABLES.keys():
		print("Compile Failed: VARIABLE name already assigned " + " ".join(operation))
		sys.exit(1)

	VARIABLES[operation[0]] = (CURRENT_ADDRESS, hex_calculator(operation[2], 'dec'))
	CURRENT_ADDRESS += 1
	return f'\t{RAM_DATA_SIGNAL} <= x"{hex_calculator(operation[2])}";\tWAIT FOR {RAM_CLOCK};\t -- {operation[0]};'

TB_LINES = []
TEST_LINES = ""
for operation in operations:
	optext = operation_text(operation)
	if operation[0] == '':
		continue

	if segment_divider(operation[0]):
		if len(SEGMENTS) > 1:
			TEST_LINES += "\n"
			
		TEST_LINES += "\t" + "-" * 66 + "\n"
		TEST_LINES += f'\t{RAM_ADDRESS_SIGNAL} <= x"{hex_calculator(str(CURRENT_ADDRESS))}";\tWAIT FOR {RAM_CLOCK};' + f"\t{RAM_ADDRESS_SIGNAL}(0) <= 'Z';\t-- " + CURRENT_SEGMENT + " SEGMENT\n"
		TEST_LINES += "\t" + "-" * 66 + "\n\n"
		continue

	if CURRENT_SEGMENT == None:
		print(f"Compile Failed: Current Segment Not Found.")
		sys.exit(1)
	elif CURRENT_SEGMENT == 'CODE':
		(opcode, dst, src) = split_operation_line(operation)
		if not opcode:
			continue
		tb_line = generate_tb_line (opcode, assign_operand(dst), assign_operand(src), optext)
		TB_LINES.append(tb_line)
	elif CURRENT_SEGMENT == 'DATA':
		TEST_LINES += assign_variable(operation) + "\n"


for tb_line in TB_LINES:
	for k, v in DECLARATIONS.items():
		tb_line = tb_line.replace('{' + k.upper() + '}', hex(v)[2:].zfill(4).upper())
	TEST_LINES += tb_line + "\n"

RESULT = RESULT.replace("{TEST_LINES}", TEST_LINES)

if not os.path.exists('output'):
	os.mkdir('output')
f = open("output/" + args.output, "w")
f.write(RESULT)
f.close()

print ("Generated VHDL file : /output/" + args.output)
	
