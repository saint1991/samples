#include "eval.h"

namespace sample {

    int EvalReversePolishNotation(const std::string& notation) {

        auto operands = Split(notation, ' ');
        std::stack<int> stack;

        for (const auto& iter : operands) {
            if (iter != "+" && iter != "-" && iter != "*") {
                stack.push(std::stoi(iter));
            } else {

                int op2 = stack.top();
                stack.pop();
                int op1 = stack.top();
                stack.pop();

                int result = 0;
                if (iter == "+") {
                    result = op1 + op2;
                } else if (iter == "-") {
                    result = op1 - op2;
                } else if (iter == "*") {
                    result = op1 * op2;
                }

                stack.push(result);
            }
        }
        return stack.top();
    }
}

