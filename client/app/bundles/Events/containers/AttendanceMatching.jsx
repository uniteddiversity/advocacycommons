import React, { Component } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

import Nav from '../components/Nav';
import AttendanceMatch from '../components/AttendanceMatch';
import { eventsPath, client } from '../utils';
import { addAlert } from '../actions';


class AttendanceMatching extends Component {
  state = { matches: [], anyMatch: true };

  componentWillMount() {
    const { id } = this.props.match.params;

    client.get(`${eventsPath()}/imports/${id}/attendances.json`)
      .then((response) => {
        this.setState({ matches: response.data, anyMatch: !!response.data.length  });
      }).catch(err => {
        let text = 'An error ocurred while retrieving the Attendances.'
        let type = 'error'
        this.props.addAlert({ text, type });
        this.setState({ anyMatch: false  });
      });
  }

  renderRows() {
    const { matches, anyMatch } = this.state;
    const { id } = this.props.match.params;

    if (anyMatch)
      return matches.map((match) => {
        return (
          <AttendanceMatch match={match} key={match.fb_rsvp.id} remote_event_id={id} />
        );
      });
  }

  renderNotMatchesMessage() {
    const { anyMatch } = this.state;

    if (!anyMatch)
      return (
        <div>
          We couldn't find any potential matches of people between the facebook and affinity version of the event.
        </div>
      )
  }

  render() {
    const { id } = this.props.match.params;
    return (
      <div>
        <Nav activeTab='events'/>

        <h2>Match Event Participants</h2>

        <br/>

        <table className='table'>
          <thead>
            <tr>
              <th colSpan='3'>Facebook Event RSVPS</th>
              <th colSpan='2'>Affinity RSVPS</th>
            </tr>
          </thead>

          <tbody>
            {this.renderRows()}
          </tbody>
        </table>
        { this.renderNotMatchesMessage() }
        <br />
        <Link className='pull-right btn btn-success'
          to={`${eventsPath()}/imports/${id}/attendances/new`}>

          Import Unmatched RSVP's
        </Link>
      </div>
    );
  }
}

export default connect(null, { addAlert })(AttendanceMatching);
