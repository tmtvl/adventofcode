import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class IntCode {
    private final CodeExecutor executor;

    private IntCode () {
	executor = new CodeExecutor(new int[] { 99 });
    }

    private IntCode (List<Integer> integers) {
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

	IntCode intCode = new IntCode();

	try {
	    Scanner fs = new Scanner(new File(argv[0])).useDelimiter(",");

	    List<Integer> ints = new ArrayList<>();

	    while (fs.hasNextInt()) {
		ints.add(fs.nextInt());
	    }

	    intCode = new IntCode(ints);
	}
	catch (FileNotFoundException fnfe) {
	    System.out.println("Can't find the input file.");
	    System.exit(1);
	}

	CodeExecutor executor = intCode.getExecutor();
	
	executor.run();
    }

    private class CodeExecutor {
	private int[] instructions;

	public CodeExecutor (int[] instructions) {
	    this.instructions = instructions;
	}

	private int execute (int pos) {
	    int opcode = instructions[pos];
	    int op = opcode % 100;
	    int verbMode = 0;
	    int nounMode = 0;
	    int targetMode = 0;

	    opcode -= op;
	    opcode /= 100;

	    if (opcode > 0) {
		verbMode = opcode % 10;
		opcode -= verbMode;
		opcode /= 10;
	    }
	    if (opcode > 0) {
		nounMode = opcode % 10;
		opcode -= nounMode;
		opcode /= 10;
	    }

	    if (op < 3) {
		int verb = instructions[pos + 1];
		int noun = instructions[pos + 2];
		int target = instructions[pos + 3];
		
		int verbValue, nounValue;

		if (verbMode == 0) {
		    verbValue = instructions[verb];
		}
		else {
		    verbValue = verb;
		}

		if (nounMode == 0) {
		    nounValue = instructions[noun];
		}
		else {
		    nounValue = noun;
		}

		if (op == 1) {
		    instructions[target] = verbValue + nounValue;
		}
		else {
		    instructions[target] = verbValue * nounValue;
		}
		
		return 4;
	    }
	    else if (op < 5) {
		int target = instructions[pos + 1];
		int targetValue;

		if (verbMode == 0) {
		    targetValue = instructions[target];
		}
		else {
		    targetValue = target; 
		}

		if (op == 3) {
		    System.out.println("Input:");
		    Scanner intScanner = new Scanner(System.in);
		    instructions[target] = intScanner.nextInt();
		}
		else {
		    System.out.println(targetValue);
		}
		return 2;
	    }
	    else {
		return -1;
	    }
	}

	public void run () {
	    int pos = 0;
	    int step = 1;

	    while (pos < instructions.length && step > 0) {
		step = execute(pos);
		pos += step;
	    }
	}
    }
}
