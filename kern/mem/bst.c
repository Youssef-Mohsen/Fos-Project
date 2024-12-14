#include "bst.h"

#include <inc/memlayout.h>
#include <inc/dynamic_allocator.h>
#include "memory_manager.h"

// struct PagesBlock
// {
//     uint8 num_pages;
// 	LIST_ENTRY(PagesBlock) prev_next_info;	/* linked list links */
// };

struct Node // a node that represents a block; a block is number of free consecutive pages
{
    int num_pages; // number of pages in that block
    struct Node *left;
    struct Node *right;
    int height;

    // // list of all blocks with this size
    // LIST_HEAD(PagesBlock_LIST, PagesBlock); // TERRIBLE SPACE USAGE
    // struct PagesBlock_LIST blocksWithThatSize;

    // list of all blocks with this size
    LIST_HEAD(Nodes_LIST, Node); // TERRIBLE SPACE USAGE
    struct Nodes_LIST nodesWithThatSize;
};


#define HIGHT(n) {(n == NULL)? 0 : n->height}

int getHeight(struct Node *n)
{
    if (n == NULL)
        return 0;
    return n->height;
}

struct Node*
createNode(int num_pages)
{
    struct Node *node = (struct Node *)malloc(sizeof(struct Node));
    node->num_pages = num_pages;
    node->left = NULL;
    node->right = NULL;
    node->height = 1; // New node is initially added at leaf
    return node;
}

int getBalanceFactor(struct Node *n)
{
    if (n == NULL)
        return 0;
    return getHeight(n->left) - getHeight(n->right);
}

struct Node*
rightRotate(struct Node *y)
{
    struct Node *x = y->left;
    struct Node *T2 = x->right;

    // Perform rotation
    x->right = y;
    y->left = T2;

    // Update heights
    y->height = MAX(getHeight(y->left), getHeight(y->right)) + 1;
    x->height = MAX(getHeight(x->left), getHeight(x->right)) + 1;

    return x;
}

struct Node*
leftRotate(struct Node *x)
{
    struct Node *y = x->right;
    struct Node *T2 = y->left;

    // Perform rotation
    y->left = x;
    x->right = T2;

    // Update heights
    x->height = MAX(getHeight(x->left), getHeight(x->right)) + 1;
    y->height = MAX(getHeight(y->left), getHeight(y->right)) + 1;

    return y;
}

// struct Node* 
// insert(struct Node *node, int num_pages)
// {
//     // 1. Perform standard BST insertion
//     if (node == NULL)
//         return createNode(num_pages);

//     if (num_pages < node->num_pages)
//         node->left = insert(node->left, num_pages);
//     else if (num_pages > node->num_pages)
//         node->right = insert(node->right, num_pages);
//     else // Equal keys are not allowed in BST
//         return node;

//     // 2. Update height of this ancestor node
//     node->height = 1 + MAX(getHeight(node->left), getHeight(node->right));

//     // 3. Get the balance factor of this ancestor node to
//     // check whether this node became unbalanced
//     int balance = getBalanceFactor(node);

//     // 4. If the node becomes unbalanced, then there are 4
//     // cases

//     // Left Left Case
//     if (balance > 1 && num_pages < node->left->num_pages)
//         return rightRotate(node);

//     // Right Right Case
//     if (balance < -1 && num_pages > node->right->num_pages)
//         return leftRotate(node);

//     // Left Right Case
//     if (balance > 1 && num_pages > node->left->num_pages)
//     {
//         node->left = leftRotate(node->left);
//         return rightRotate(node);
//     }

//     // Right Left Case
//     if (balance < -1 && num_pages < node->right->num_pages)
//     {
//         node->right = rightRotate(node->right);
//         return leftRotate(node);
//     }

//     // Return the (unchanged) node pointer
//     return node;
// }

struct Node*
insert(struct Node *root, struct Node *to_insert)
{
    // 1. Perform standard BST insertion
    if (root == NULL)
        //return createNode(num_pages);
        return to_insert;

    if (to_insert->num_pages < root->num_pages)
        root->left = insert(root->left, to_insert);
    else if (to_insert->num_pages > root->num_pages)
        root->right = insert(root->right, to_insert);
    else // Equal keys are not allowed in BST
        LIST_INSERT_HEAD(root->nodesWithThatSize, to_insert);

    // 2. Update height of this ancestor node
    root->height = 1 + MAX(getHeight(root->left), getHeight(root->right));

    // 3. Get the balance factor of this ancestor node to
    // check whether this node became unbalanced
    int balance = getBalanceFactor(root);

    // 4. If the node becomes unbalanced, then there are 4
    // cases

    // Left Left Case
    if (balance > 1 && to_insert->num_pages < root->left->num_pages)
        return rightRotate(root);

    // Right Right Case
    if (balance < -1 && to_insert->num_pages > root->right->num_pages)
        return leftRotate(root);

    // Left Right Case
    if (balance > 1 && to_insert->num_pages > root->left->num_pages)
    {
        root->left = leftRotate(root->left);
        return rightRotate(root);
    }

    // Right Left Case
    if (balance < -1 && to_insert->num_pages < root->right->num_pages)
    {
        root->right = rightRotate(root->right);
        return leftRotate(root);
    }

    // Return the (unchanged) node pointer
    return root;
}


// Function to perform preorder traversal of AVL tree
void inOrder(struct Node *root)
{
    if (root != NULL)
    {
        inOrder(root->left);
        printf("%d ", root->num_pages);
        inOrder(root->right);
    }
}
