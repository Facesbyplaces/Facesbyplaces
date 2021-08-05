module Transactionable
    include ApplicationConcern
  
    def set_transactions
        transactions = Transaction.all         
        @transactions = transactions.page(params[:page]).per(numberOfPage)
    end

    def set_transaction
        @transaction = Transaction.find(params[:id])
    end 
end