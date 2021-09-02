module Transactionable
    include ApplicationConcern
  
    def set_transactions
        transactions = Transaction.all.order("transactions.id DESC")
        @transactions = transactions.page(params[:page]).per(numberOfPage)
    end

    def set_transaction
        @transaction = Transaction.find(params[:id])
    end 

    def itemsRemaining(data)
        if data.total_count == 0 || (data.total_count - (params[:page].to_i * numberOfPage)) < 0
            return itemsremaining = 0
        elsif data.total_count < numberOfPage
            return itemsremaining = data.total_count 
        else
            return itemsremaining = data.total_count - (params[:page].to_i * numberOfPage)
        end
    end

end