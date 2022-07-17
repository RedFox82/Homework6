public class Queue {

    private List<Object> queue_object = new List<Object>();

//Create new queue-object
    public void Queue() {
        this.queue_object = queue_object;
    }

//Add new element to left-side of queue
    public void push(Object object_Push) {
        if (this.queue_object.isEmpty()) {
            this.queue_object.add(object_Push);
        } else {
            Integer old_length = this.queue_object.size();

            this.queue_object.add(null);

            for(Integer i = 0; i < old_length; i++) {
                this.queue_object.set(old_length - i, this.queue_object[old_length - i - 1]);
            }
            this.queue_object.set(0, object_Push);
        }
    }

//Remove element from right-side queue
    public Object pop() {
        if (!this.queue_object.isEmpty()) {
            return this.queue_object.remove(this.queue_object.size() - 1);
        }
        return null;
    }

//----------------------debug section-----------------------

//Get element from right-side queue without deleting
    public Object get_element() {
        if (!this.queue_object.isEmpty()) {
            return this.queue_object[this.queue_object.size() - 1];
        }
        return null;
    }


}