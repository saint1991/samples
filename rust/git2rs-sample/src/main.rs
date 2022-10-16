use git2;
use git2::BranchType;
use git2::build::CheckoutBuilder;

const BRANCH_MASTER: &str = "master";
const BRANCH_A: &str = "branch-a";
const BRANCH_B: &str = "branch-b";
const BRANCH_C: &str = "branch-c";

fn main() {
    let local_path = "/Users/seiya/Desktop/projects/git-sample";
    let repo = git2::Repository::open(local_path).unwrap();

    let mut opt = CheckoutBuilder::new();
    opt.force();
    checkout_branch_like_git_cli(&repo, BRANCH_C, Some(&mut opt)).unwrap();
}

fn to_refname(rev_spec: &str) -> String {
    format!("refs/heads/{}", rev_spec)
}

/// checkout as git cli does
/// See https://git-scm.com/docs/gitrevisions to know what to put in rev_spec.
fn checkout_branch_like_git_cli(repository: &git2::Repository, branch: &str, opt: Option<&mut CheckoutBuilder>) -> Result<(), git2::Error> {
    let refname = to_refname(branch);

    repository.revparse_single(&refname).and_then(|treeish| {
        repository.checkout_tree(&treeish, opt)
    }).and_then(|()| {
        repository.set_head(&refname)
    })
}
