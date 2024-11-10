#[starknet::interface]
trait IVotingContract <TContractState> {
    fn vote (ref self: TContractState, vote: u8 );
    fn get_votes(self: @TContractState) -> (u8, u8) ;
}

#[starknet::contract]
mod VotingContract {
    use starknet::get_caller_address;
    use starknet::ContractAddress;
    use core::starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
    use starknet::storage::Map;
   
#[storage]
struct Storage {
        // proposals: LegacyMap::<u8, u8>,
        voters: Map::<ContractAddress, bool>,
        no_vote: u8,
        yes_vote: u8,
}

#[abi(embed_v0)]
impl VotingContractImpl of super::IVotingContract<ContractState> {
    // fn add_proposal(ref self: ContractState, proposal: u8) {
    //         self.proposals.write(proposal);
    // } 
    fn vote(ref self: ContractState, vote: u8) {
        assert((vote == 0) || (vote == 1), 'vote can only be 0 or 1');
        let _caller = get_caller_address();

        let already_voted = self.voters.read(_caller); // This will return a u8 value
        assert(already_voted == true, 'you have already voted'); 


        if vote == 0 {
            self.no_vote.write(self.no_vote.read() + 1)
        } else if vote == 1 {
            self.yes_vote.write(self.yes_vote.read() + 1)
        }

        self.voters.write(_caller, true);
    } 

    fn get_votes(self: @ContractState) -> (u8, u8) {
        let no_vote =  self.no_vote.read(); 
        let yes_vote =   self.yes_vote.read();
        return (no_vote, yes_vote);
    }
    }
}   