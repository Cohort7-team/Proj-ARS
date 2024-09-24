resource "aws_iam_user" "vault_admin_user" {
  name = var.vault_admin
  path = "/"

  tags = {
    name = "vault-admin"
  }
}

resource "aws_iam_access_key" "vault_admin_key" {
  user = aws_iam_user.vault_admin_user.name
}

data "aws_iam_policy_document" "vault_admin_policy" {
  statement {
    effect    = "Allow"
    actions   = [
        "iam:AttachUserPolicy",
        "iam:CreateUser",
        "iam:CreateAccessKey",
        "iam:DeleteUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:GetUser",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup"
        ]
    resources = [
    "arn:aws:iam::539247453744:user/vault-*"
        ]
  }
}

resource "aws_iam_user_policy" "vault_admin_policy" {
  name   = "vault-admin-policy"
  user   = aws_iam_user.vault_admin_user.name
  policy = data.aws_iam_policy_document.vault_admin_policy.json
}