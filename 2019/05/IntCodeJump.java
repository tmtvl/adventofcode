import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class IntCodeJump {
    private final CodeExecutor executor;

    private IntCodeJump () {
	executor = new CodeExecutor(new int[] { 99 });
    }

    private IntCodeJump (List<Integer> integers) {
	int[] ints = new int[integers.size()];

	for (int i = 0; i < integers.size(); i++) {
	    ints[i] = integers.get(i);
	}
	
	executor = new CodeExecutor(ints);
    }

    public CodeExecutor getExecutor () {
	return executor;
    }
	
    public static void main (String[] argv) {
	if (argv.length != 1) {
	    System.out.println("Please provide the input file.");
	    System.exit(1);
	}

	IntCodeJump intCode = new IntCodeJump();

	try {
	    Scanner fs = new Scanner(new File(argv[0])).useDelimiter(",");

	    List<Integer> ints = new ArrayList<>();

	    while (fs.hasNextInt()) {
		ints.add(fs.nextInt());
	    }

	    ints.add(Integer.parseInt(fs.next().trim()));

	    intCode = new IntCodeJump(ints);
	}
	catch (FileNotFoundException fnfe) {
	    System.out.println("Can't find the input file.");
	    System.exit(1);
	}

	CodeExecutor executor = intCode.getExecutor();
	
	executor.run();
    }

    private class OpCode {
	public int op;
	public int verbMode;
	public int nounMode;
	
	public OpCode (int opCode) {
	    op = opCode % 100;
	    verbMode = 0;
	    nounMode = 0;

	    opCode -= op;
	    opCode /= 100;

	    if (opCode > 0) {
		verbMode = opCode % 10;
		opCode -= verbMode;
		opCode /= 10;
	    }
	    if (opCode > 0) {
		nounMode = opCode % 10;
		opCode -= nounMode;
		opCode /= 10;
	    }
	}
    }

    private interface MathOperation {
	public int calculate (int a, int b);
    }

    private class AddOperation implements MathOperation {
	@Override
	public int calculate (int a, int b) {
	    return a + b;
	}

	@Override
	public String toString () {
	    return "+";
	}
    }

    private class MultiplyOperation implements MathOperation {
	@Override
	public int calculate (int a, int b) {
	    return a * b;
	}

	@Override
	public String toString () {
	    return "*";
	}
    }

    private interface CompareOperation {
	public boolean comparison (int a, int b);
    }

    private class LessThanOperation implements CompareOperation {
	@Override
	public boolean comparison (int a, int b) {
	    return a < b;
	}

	@Override
	public String toString () {
	    return "<";
	}
    }

    private class EqualOperation implements CompareOperation {
	@Override
	public boolean comparison (int a, int b) {
	    return a == b;
	}

	@Override
	public String toString () {
	    return "==";
	}
    }

    private class CodeExecutor {
	private int ADD        = 1;
	private int MULTIPLY   = 2;
	private int READ       = 3;
	private int PRINT      = 4;
	private int JUMP_TRUE  = 5;
	private int JUMP_FALSE = 6;
	private int LESS_THAN  = 7;
	private int EQUAL      = 8;
	private int DONE       = 99;
	
	private int[] instructions;
	private int pos = 0;

	private MathOperation addOp = new AddOperation();
	private MathOperation multOp = new MultiplyOperation();
	private CompareOperation ltOp = new LessThanOperation();
	private CompareOperation eqOp = new EqualOperation();

	public CodeExecutor (int[] instructions) {
	    this.instructions = instructions;
	}

	private int getValue (int value, int mode) {
	    if (mode == 0) {
		return instructions[value];
	    } else {
		return value;
	    }
	}

	private OpCode getOp () {
	    return new OpCode(instructions[pos]);
	}

	private void doMath (MathOperation op, int verbMode, int nounMode) {
	    int verb   = getValue(instructions[pos + 1], verbMode);
	    int noun   = getValue(instructions[pos + 2], nounMode);

	    instructions[instructions[pos + 3]] = op.calculate(verb, noun);
	    pos += 4;
	}

	private void add (int verbMode, int nounMode) {
	    doMath(addOp, verbMode, nounMode);
	}

	private void multiply (int verbMode, int nounMode) {
	    doMath(multOp, verbMode, nounMode);
	}

	private void read () {
	    System.out.println("Input:");

	    Scanner intScanner = new Scanner(System.in);

	    instructions[instructions[pos + 1]] = intScanner.nextInt();
	    
	    pos += 2;
	}

	private void print (int verbMode) {
	    int verb = getValue(instructions[pos + 1], verbMode);

	    System.out.println(verb);
	    
	    pos += 2;
	}

	private void jump (int nounMode) {
	    int noun = getValue(instructions[pos + 2], nounMode);

	    pos = noun;
	}

	private void jumpTrue (int verbMode, int nounMode) {
	    int verb = getValue(instructions[pos + 1], verbMode);

	    if (verb != 0) {
		jump(nounMode);
	    } else {
		pos += 3;
	    }
	}

	private void jumpFalse (int verbMode, int nounMode) {
	    int verb = getValue(instructions[pos + 1], verbMode);

	    if (verb == 0) {
		jump(nounMode);
	    } else {
		pos += 3;
	    }
	}

	private void comparison (CompareOperation op, int verbMode, int nounMode) {
	    int verb   = getValue(instructions[pos + 1], verbMode);
	    int noun   = getValue(instructions[pos + 2], nounMode);
	    int target = instructions[pos + 3];

	    if (op.comparison(verb, noun)) {
		instructions[target] = 1;
	    }
	    else {
		instructions[target] = 0;
	    }

	    pos += 4;
	}

	private void lessThan (int verbMode, int nounMode) {
	    comparison(ltOp, verbMode, nounMode);
	}

	private void equal (int verbMode, int nounMode) {
	    comparison(eqOp, verbMode, nounMode);
	}

	public void run () {
	    OpCode op = getOp();

	    while (op.op != DONE) {
		if (op.op == ADD) {
		    add(op.verbMode, op.nounMode);
		} else if (op.op == MULTIPLY) {
		    multiply(op.verbMode, op.nounMode);
		} else if (op.op == READ) {
		    read();
		} else if (op.op == PRINT) {
		    print(op.verbMode);
		} else if (op.op == JUMP_TRUE) {
		    jumpTrue(op.verbMode, op.nounMode);
		} else if (op.op == JUMP_FALSE) {
		    jumpFalse(op.verbMode, op.nounMode);
		} else if (op.op == LESS_THAN) {
		    lessThan(op.verbMode, op.nounMode);
		} else if (op.op == EQUAL) {
		    equal(op.verbMode, op.nounMode);
		} else {
		    pos++;
		}
		
		op = getOp();
	    }
	}
    }
}
