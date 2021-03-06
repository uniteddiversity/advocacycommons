import { FETCH_EVENTS } from '../actions/types';

const INITIAL_STATE = {
  events: [],
  page: 1,
  total_pages: null
};

const EventsReducer = (state = INITIAL_STATE, action) => {
  switch (action.type) {
  case FETCH_EVENTS: {
    const { events, page, total_pages } = action.payload.data
    return { page, total_pages, events: events.data };
  }
  default:
    return state;
  }
};

export default EventsReducer;
