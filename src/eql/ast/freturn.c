#include <stdlib.h>
#include "../../dbg.h"

#include "node.h"

//==============================================================================
//
// Functions
//
//==============================================================================

//--------------------------------------
// Lifecycle
//--------------------------------------

// Creates an AST node for a function return.
//
// value - The value to be returned.
// ret   - A pointer to where the ast node will be returned.
//
// Returns 0 if successful, otherwise returns -1.
int eql_ast_freturn_create(struct eql_ast_node *value, struct eql_ast_node **ret)
{
    eql_ast_node *node = malloc(sizeof(eql_ast_node)); check_mem(node);
    node->type = EQL_AST_TYPE_FRETURN;
    node->parent = NULL;
    node->freturn.value = value;
    if(value) {
        value->parent = node;
    }

    *ret = node;
    return 0;

error:
    eql_ast_node_free(node);
    (*ret) = NULL;
    return -1;
}

// Frees a variable declaration AST node from memory.
//
// node - The AST node to free.
void eql_ast_freturn_free(struct eql_ast_node *node)
{
    if(node->freturn.value) eql_ast_node_free(node->freturn.value);
    node->freturn.value = NULL;
}


//--------------------------------------
// Codegen
//--------------------------------------

int eql_ast_freturn_codegen(eql_ast_node *node, eql_module *module,
                            LLVMValueRef *value)
{
    check(node != NULL, "Node is required");
    check(node->type == EQL_AST_TYPE_FRETURN, "Node must be a function return");
    
    LLVMBuilderRef builder = module->compiler->llvm_builder;

    // Return value if specified.
    if(node->freturn.value) {
        LLVMValueRef return_value = NULL;
        int rc = eql_ast_node_codegen(node->freturn.value, module, &return_value);
        check(rc == 0, "Unable to codegen function return value");
        check(return_value != NULL, "Missing return value");
        *value = LLVMBuildRet(builder, return_value);
        check(*value != NULL, "Unable to generate function return");
    }
    // Otherwise return void.
    else {
        *value = LLVMBuildRetVoid(builder);
        check(*value != NULL, "Unable to generate function return void");
    }
    
    return 0;

error:
    *value = NULL;
    return -1;
}


//--------------------------------------
// Debugging
//--------------------------------------

// Append the contents of the AST node to the string.
// 
// node - The node to dump.
// ret  - A pointer to the bstring to concatenate to.
//
// Return 0 if successful, otherwise returns -1.s
int eql_ast_freturn_dump(eql_ast_node *node, bstring ret)
{
    int rc;
    check(node != NULL, "Node required");
    check(ret != NULL, "String required");

    // Append dump.
    check(bcatcstr(ret, "<freturn>\n") == BSTR_OK, "Unable to append dump");

    // Recursively dump children.
    if(node->freturn.value != NULL) {
        rc = eql_ast_node_dump(node->freturn.value, ret);
        check(rc == 0, "Unable to dump return value");
    }

    return 0;

error:
    return -1;
}
