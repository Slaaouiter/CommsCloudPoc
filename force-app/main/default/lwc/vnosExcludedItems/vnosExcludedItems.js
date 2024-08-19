import { LightningElement, api, track } from 'lwc';
import excludedItemsTemplate from './vnosExcludedItems.html';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import pubsub from 'vlocity_cmt/pubsub';

export default class VnosExcludedItems extends OmniscriptBaseMixin(LightningElement) {

    @track _items;

    @api
    get items() {
        return this._items;
    }
    set items(data) {
        try {

            if (data) {

                // Compute UI fields to help us render it easily (regardless of CPQv2 vs. Digital Commerce APIs)
                this._items = JSON.parse(JSON.stringify(data));
            }
        } catch (err) {
            console.error("Error in set items() -> " + err);
        }
    }

    addItem(event) {
        pubsub.fire("addItem", "result", {
            code: event.target.getAttribute("data-attributecode"),
            addon: event.target.getAttribute("data-addon") === 'true',
            promotion: event.target.getAttribute("data-promotion") === 'true'
        });
    }



    render() {
        return excludedItemsTemplate;
    }
}